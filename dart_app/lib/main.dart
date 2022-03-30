import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/screens/auth/auth.dart';
import 'package:dart_app/screens/auth/forgot_password.dart';
import 'package:dart_app/screens/game_modes/x01/finish/finish.dart';
import 'package:dart_app/screens/game_modes/x01/game/game.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/game_settings.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics.dart/game_statistics.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/ingame_settings.dart';
import 'package:dart_app/screens/home/home.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/services/firestore_service.dart';
import 'package:dart_app/utils/globals.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) =>
              AuthService(FirebaseAuth.instance, FirebaseFirestore.instance),
        ),
        Provider<FirestoreService>(
          create: (_) => FirestoreService(
            FirebaseFirestore.instance,
            FirebaseAuth.instance,
          ),
        ),
        StreamProvider(
            create: (context) => context.read<AuthService>().authStateChanges,
            initialData: null),
        ChangeNotifierProvider(
          create: (_) => GameSettingsX01(),
        ),
        ChangeNotifierProvider(
          create: (_) => GameX01(),
        ),
      ],
      child: Sizer(builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          title: 'Dart',
          theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)),
          routes: {
            Auth.routeName: (ctx) => Auth(),
            Home.routeName: (ctx) => Home(),
            ForgotPassword.routeName: (ctx) => ForgotPassword(),
            GameSettings.routeName: (ctx) => GameSettings(),
            Game.routeName: (ctx) => Game(),
            InGameSettings.routeName: (ctx) => InGameSettings(),
            Finish.routeName: (ctx) => Finish(),
            GameStatistics.routeName: (ctx) => GameStatistics(),
          },
          home: AuthWrapper(),
        );
      }),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return Home();
    }
    return Auth();
  }
}
