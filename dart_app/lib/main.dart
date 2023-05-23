import 'package:dart_app/models/auth.dart';
import 'package:dart_app/models/firestore/stats_firestore_c.dart';
import 'package:dart_app/models/firestore/stats_firestore_s_t.dart';
import 'package:dart_app/models/firestore/stats_firestore_sc_t.dart';
import 'package:dart_app/models/firestore/stats_firestore_d_t.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/models/game_settings/game_settings_single_double_training_p.dart';
import 'package:dart_app/models/game_settings/x01/default_settings_x01_p.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/firestore/open_games_firestore.dart';
import 'package:dart_app/models/firestore/stats_firestore_x01_p.dart';
import 'package:dart_app/screens/auth/login_register_page.dart';
import 'package:dart_app/screens/auth/local_widgets/forgot_password.dart';
import 'package:dart_app/screens/game_modes/cricket/finish/finish_c.dart';
import 'package:dart_app/screens/game_modes/cricket/game/game_c.dart';
import 'package:dart_app/screens/game_modes/cricket/game_settings/game_settings_c.dart';
import 'package:dart_app/screens/game_modes/score_training/finish/finish_sc_t.dart';
import 'package:dart_app/screens/game_modes/score_training/game/game_sc_t.dart';
import 'package:dart_app/screens/game_modes/score_training/game_settings/game_settings_sc_t.dart';
import 'package:dart_app/screens/game_modes/score_training/game_statistics/game_stats_sc_t.dart';
import 'package:dart_app/screens/game_modes/open_games/open_games.dart';
import 'package:dart_app/screens/game_modes/single_double_training/game_settings/game_settings_sd_t.dart';
import 'package:dart_app/screens/game_modes/single_double_training/game_statistics/game_stats_sd_t.dart';
import 'package:dart_app/screens/game_modes/x01/finish/finish_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/game_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/game_settings_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/game_stats_x01.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/ingame_settings_x01.dart';
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

import 'screens/game_modes/cricket/statistics/game_stats_c.dart';
import 'screens/game_modes/single_double_training/finish/finish_sd_t.dart';
import 'screens/game_modes/single_double_training/game/game_sd_t.dart';

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
    final Color color = Color.fromARGB(255, 49, 89, 136);

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
          create: (_) => GameX01_P(),
        ),
        ChangeNotifierProvider(
          create: (_) => StatsFirestoreX01_P(),
        ),
        ChangeNotifierProvider(
          create: (_) => OpenGamesFirestore(),
        ),
        ChangeNotifierProvider(
          create: (_) => DefaultSettingsX01_P(),
        ),
        ChangeNotifierProvider(
          create: (_) => Auth_P(),
        ),
        ChangeNotifierProvider(
          create: (_) => GameSettingsScoreTraining_P(),
        ),
        ChangeNotifierProvider(
          create: (_) => GameScoreTraining_P(),
        ),
        ChangeNotifierProvider(
          create: (_) => StatsFirestoreDoubleTraining_P(),
        ),
        ChangeNotifierProvider(
          create: (_) => StatsFirestoreSingleTraining_P(),
        ),
        ChangeNotifierProvider(
          create: (_) => StatsFirestoreScoreTraining_P(),
        ),
        ChangeNotifierProvider(
          create: (_) => GameSingleDoubleTraining_P(),
        ),
        ChangeNotifierProvider(
          create: (_) => GameSettingsSingleDoubleTraining_P(),
        ),
        ChangeNotifierProvider(
          create: (_) => GameSettingsCricket_P(),
        ),
        ChangeNotifierProvider(
          create: (_) => GameCricket_P(),
        ),
        ChangeNotifierProvider(
          create: (_) => StatsFirestoreCricket_P(),
        ),
      ],
      child: Sizer(builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          title: 'Dart',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: color,
              secondary: Color.fromARGB(255, 222, 176, 134),
            ),
            scaffoldBackgroundColor: color,
          ),
          routes: {
            LoginRegisterPage.routeName: (ctx) => LoginRegisterPage(),
            Home.routeName: (ctx) => Home(),
            ForgotPassword.routeName: (ctx) => ForgotPassword(),
            GameSettingsX01.routeName: (ctx) => GameSettingsX01(),
            GameX01.routeName: (ctx) => GameX01(),
            InGameSettingsX01.routeName: (ctx) => InGameSettingsX01(),
            FinishX01.routeName: (ctx) => FinishX01(),
            GameStatisticsX01.routeName: (ctx) => GameStatisticsX01(),
            StatsPerGameList.routeName: (ctx) => StatsPerGameList(),
            StatsPerGameFilteredList.routeName: (ctx) =>
                StatsPerGameFilteredList(),
            OpenGames.routeName: (ctx) => OpenGames(),
            GameSettingsScoreTraining.routeName: (ctx) =>
                GameSettingsScoreTraining(),
            GameScoreTraining.routeName: (ctx) => GameScoreTraining(),
            FinishScoreTraining.routeName: (ctx) => FinishScoreTraining(),
            GameStatsScoreTraining.routeName: (ctx) => GameStatsScoreTraining(),
            GameSettingsSingleDoubleTraining.routeName: (ctx) =>
                GameSettingsSingleDoubleTraining(),
            GameSingleDoubleTraining.routeName: (ctx) =>
                GameSingleDoubleTraining(),
            FinishSingleDoubleTraining.routeName: (ctx) =>
                FinishSingleDoubleTraining(),
            GameStatsSingleDoubleTraining.routeName: (ctx) =>
                GameStatsSingleDoubleTraining(),
            GameSettingsCricket.routeName: (ctx) => GameSettingsCricket(),
            GameCricket.routeName: (ctx) => GameCricket(),
            FinishCricket.routeName: (ctx) => FinishCricket(),
            StatisticsCricket.routeName: (ctx) => StatisticsCricket(),
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
