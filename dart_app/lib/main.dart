import 'package:dart_app/models/auth.dart';
import 'package:dart_app/models/game_settings/score_training/game_settings_score_training_p.dart';
import 'package:dart_app/models/game_settings/x01/default_settings_x01_p.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01.dart';
import 'package:dart_app/models/firestore/open_games_firestore.dart';
import 'package:dart_app/models/firestore/x01/statistics_firestore_x01_p.dart';
import 'package:dart_app/screens/auth/login_register_page.dart';
import 'package:dart_app/screens/auth/local_widgets/forgot_password.dart';
import 'package:dart_app/screens/game_modes/score_training/game_settings/game_settings.dart';
import 'package:dart_app/screens/game_modes/x01/open_games/open_games.dart';
import 'package:dart_app/screens/game_modes/x01/finish/finish.dart';
import 'package:dart_app/screens/game_modes/x01/game/game.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/game_settings_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/game_statistics.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/ingame_settings.dart';
import 'package:dart_app/screens/home/home.dart';
import 'package:dart_app/screens/statistics/local_widgets/stats_per_game_filtered_list/stats_per_game_filtered_list.dart';
import 'package:dart_app/screens/statistics/local_widgets/stats_per_game_list.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/services/firestore/firestore_service_default_settings.dart';
import 'package:dart_app/services/firestore/firestore_service_player_stats.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';

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
    Color color = Color.fromARGB(255, 49, 89, 136);

    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) =>
              AuthService(FirebaseAuth.instance, FirebaseFirestore.instance),
        ),
        Provider<FirestoreServiceDefaultSettings>(
          create: (_) => FirestoreServiceDefaultSettings(
            FirebaseFirestore.instance,
            FirebaseAuth.instance,
          ),
        ),
        Provider<FirestoreServiceGames>(
          create: (_) => FirestoreServiceGames(
            FirebaseFirestore.instance,
            FirebaseAuth.instance,
          ),
        ),
        Provider<FirestoreServicePlayerStats>(
          create: (_) => FirestoreServicePlayerStats(
            FirebaseFirestore.instance,
            FirebaseAuth.instance,
          ),
        ),
        StreamProvider(
            create: (context) => context.read<AuthService>().authStateChanges,
            initialData: null),
        ChangeNotifierProvider(
          create: (_) => GameSettingsX01_P(),
        ),
        ChangeNotifierProvider(
          create: (_) => GameX01(),
        ),
        ChangeNotifierProvider(
          create: (_) => StatisticsFirestoreX01_P(),
        ),
        ChangeNotifierProvider(
          create: (_) => OpenGamesFirestore(),
        ),
        ChangeNotifierProvider(
          create: (_) => DefaultSettingsX01_P(),
        ),
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (_) => GameSettingsScoreTraining_P(),
        ),
      ],
      child: Sizer(builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          title: 'Dart',
          theme: ThemeData(
            /* colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blue,
              accentColor: Colors.green,
            ), */
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: color,
              secondary: Color.fromARGB(255, 222, 176, 134),

              // secondary: Color.fromARGB(255, 7, 56, 96),
            ),
            scaffoldBackgroundColor: color,
          ),
          routes: {
            LoginRegisterPage.routeName: (ctx) => LoginRegisterPage(),
            Home.routeName: (ctx) => Home(),
            ForgotPassword.routeName: (ctx) => ForgotPassword(),
            GameSettingsX01.routeName: (ctx) => GameSettingsX01(),
            Game.routeName: (ctx) => Game(),
            InGameSettings.routeName: (ctx) => InGameSettings(),
            Finish.routeName: (ctx) => Finish(),
            GameStatistics.routeName: (ctx) => GameStatistics(),
            StatsPerGameList.routeName: (ctx) => StatsPerGameList(),
            StatsPerGameFilteredList.routeName: (ctx) =>
                StatsPerGameFilteredList(),
            OpenGames.routeName: (ctx) => OpenGames(),
            GameSettingsScoreTraining.routeName: (ctx) =>
                GameSettingsScoreTraining(),
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
    return LoginRegisterPage();
  }
}
