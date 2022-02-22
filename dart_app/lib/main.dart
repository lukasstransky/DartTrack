import 'package:dart_app/models/game_settings/game_settings_x01_model.dart';
import 'package:dart_app/screens/x01/game_x01_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import './services/auth_service.dart';
import './screens/home_screen.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/x01/game_settings_x01_screen.dart';
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
        StreamProvider(
            create: (context) => context.read<AuthService>().authStateChanges,
            initialData: null),
        ChangeNotifierProvider(
          create: (_) => GameSettingsX01(),
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
            AuthScreen.routeName: (ctx) => AuthScreen(),
            HomeScreen.routeName: (ctx) => HomeScreen(),
            ForgotPasswordScreen.routeName: (ctx) => ForgotPasswordScreen(),
            GameSettingsX01Screen.routeName: (ctx) => GameSettingsX01Screen(),
            GameX01Screen.routeName: (ctx) => GameX01Screen(),
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
      return HomeScreen();
    }
    return AuthScreen();
  }
}
