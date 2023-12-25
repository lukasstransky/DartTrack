import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/default_settings_x01_p.dart';
import 'package:dart_app/models/firestore/open_games_firestore.dart';
import 'package:dart_app/models/game_settings/x01/helper/default_settings_helper.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/services/firestore/firestore_service_default_settings.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:dart_app/utils/button_styles.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class GameModesOverView extends StatefulWidget {
  const GameModesOverView({Key? key}) : super(key: key);

  @override
  _GameModesOverViewScreenState createState() =>
      _GameModesOverViewScreenState();
}

class _GameModesOverViewScreenState extends State<GameModesOverView> {
  @override
  initState() {
    _getOpenGames();
    _getDefaultSettingsX01();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DefaultSettingsX01_P defaultSettingsX01 =
        context.read<DefaultSettingsX01_P>();
    final OpenGamesFirestore openGamesFirestore =
        context.read<OpenGamesFirestore>();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: CustomAppBar(showBackBtn: false, title: 'Game modes'),
        body: defaultSettingsX01.loadSettings ||
                openGamesFirestore.getLoadOpenGames
            ? Center(
                child: CircularProgressIndicator(
                color: Colors.white,
              ))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  OpenGames(),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            X01Btn(),
                            CricketBtn(),
                            SingleTrainingBtn(),
                            DoubleTrainingBtn(),
                            ScoreTrainingBtn(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  _getOpenGames() async {
    final OpenGamesFirestore openGamesFirestore =
        context.read<OpenGamesFirestore>();
    final bool isConnected = await Utils.hasInternetConnection();

    if (!isConnected) {
      openGamesFirestore.setLoadOpenGames = false;
      setState(() {});

      return;
    }

    if (openGamesFirestore.getLoadOpenGames) {
      openGamesFirestore.setLoadOpenGames = false;
      await context
          .read<FirestoreServiceGames>()
          .getOpenGames(openGamesFirestore);
      setState(() {});
    }
  }

  _getDefaultSettingsX01() async {
    final bool isConnected = await Utils.hasInternetConnection();
    final DefaultSettingsX01_P defaultSettingsX01 =
        context.read<DefaultSettingsX01_P>();

    if (!isConnected) {
      defaultSettingsX01.loadSettings = false;
      setState(() {});
      return;
    }

    final String username =
        context.read<AuthService>().getUsernameFromSharedPreferences() ?? '';

    if (defaultSettingsX01.loadSettings) {
      defaultSettingsX01.resetValues(username);
      await context
          .read<FirestoreServiceDefaultSettings>()
          .getDefaultSettingsX01(context);
      defaultSettingsX01.loadSettings = false;
      setState(() {});
    } else if (username == 'Guest') {
      defaultSettingsX01.resetValues(username);
      DefaultSettingsHelper.setSettingsFromDefault(context);
    }
  }
}

class ScoreTrainingBtn extends StatelessWidget {
  const ScoreTrainingBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: GAME_MODES_OVERVIEW_WIDTH.w,
      height: GAME_MODES_OVERVIEW_HEIGHT.h,
      child: ElevatedButton(
        child: Text(
          GameMode.ScoreTraining.name,
          style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
              color: Theme.of(context).colorScheme.secondary),
        ),
        onPressed: () {
          Utils.handleVibrationFeedback(context);
          Navigator.of(context).pushNamed('/settingsScoreTraining');
        },
        style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DoubleTrainingBtn extends StatelessWidget {
  const DoubleTrainingBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: GAME_MODES_OVERVIEW_PADDING.h),
      child: Container(
        width: GAME_MODES_OVERVIEW_WIDTH.w,
        height: GAME_MODES_OVERVIEW_HEIGHT.h,
        child: ElevatedButton(
          child: Text(
            GameMode.DoubleTraining.name,
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                color: Theme.of(context).colorScheme.secondary),
          ),
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            Navigator.of(context).pushNamed(
              '/settingsSingleDoubleTraining',
              arguments: {'mode': GameMode.DoubleTraining},
            );
          },
          style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SingleTrainingBtn extends StatelessWidget {
  const SingleTrainingBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: GAME_MODES_OVERVIEW_PADDING.h),
      child: Container(
        width: GAME_MODES_OVERVIEW_WIDTH.w,
        height: GAME_MODES_OVERVIEW_HEIGHT.h,
        child: ElevatedButton(
          child: Text(
            GameMode.SingleTraining.name,
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                color: Theme.of(context).colorScheme.secondary),
          ),
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            Navigator.of(context).pushNamed(
              '/settingsSingleDoubleTraining',
              arguments: {
                'mode': GameMode.SingleTraining,
              },
            );
          },
          style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CricketBtn extends StatelessWidget {
  const CricketBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: GAME_MODES_OVERVIEW_PADDING.h),
      child: Container(
        width: GAME_MODES_OVERVIEW_WIDTH.w,
        height: GAME_MODES_OVERVIEW_HEIGHT.h,
        child: ElevatedButton(
          child: Text(
            GameMode.Cricket.name,
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                color: Theme.of(context).colorScheme.secondary),
          ),
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            Navigator.of(context).pushNamed('/settingsCricket');
          },
          style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class X01Btn extends StatelessWidget {
  const X01Btn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: GAME_MODES_OVERVIEW_PADDING.h),
      child: Container(
        width: GAME_MODES_OVERVIEW_WIDTH.w,
        height: GAME_MODES_OVERVIEW_HEIGHT.h,
        child: ElevatedButton(
          child: Text(
            GameMode.X01.name,
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                color: Theme.of(context).colorScheme.secondary),
          ),
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            Navigator.of(context).pushNamed('/settingsX01');
          },
          style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OpenGames extends StatelessWidget {
  const OpenGames({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.w,
      padding: EdgeInsets.only(right: 3.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Open games: ',
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              color: Colors.white,
            ),
          ),
          Container(
            height: 4.h,
            child: ElevatedButton(
              child: Selector<OpenGamesFirestore, List<Game_P>>(
                selector: (_, openGamesFirestore) =>
                    openGamesFirestore.openGames,
                shouldRebuild: (previous, next) => true,
                builder: (_, openGames, __) => Text(
                  openGames.length.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  ),
                ),
              ),
              onPressed: () {
                Utils.handleVibrationFeedback(context);
                Navigator.of(context).pushNamed('/openGames');
              },
              style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
