import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/default_settings_x01_p.dart';
import 'package:dart_app/models/firestore/open_games_firestore.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/services/firestore/firestore_service_default_settings.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:dart_app/utils/utils.dart';
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
    //todo move _getDefaultSettingsX01
    _getDefaultSettingsX01();
    super.initState();
  }

  _getOpenGames() async {
    await context.read<FirestoreServiceGames>().getOpenGames(context);
  }

  _getDefaultSettingsX01() async {
    context
        .read<DefaultSettingsX01_P>()
        .resetValues(context.read<AuthService>().getPlayer);
    await context
        .read<FirestoreServiceDefaultSettings>()
        .getDefaultSettingsX01(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showBackBtn: false, title: 'Game Modes'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          OpenGames(),
          Expanded(
            child: Center(
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
        ],
      ),
    );
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
          'Score training',
          style: TextStyle(
              fontSize: GAME_MODES_OVERVIEW_FONTSIZE.sp,
              color: Theme.of(context).colorScheme.secondary),
        ),
        onPressed: () =>
            Navigator.of(context).pushNamed('/settingsScoreTraining'),
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          backgroundColor: MaterialStateProperty.all(
            Utils.darken(Theme.of(context).colorScheme.primary, GENERAL_DARKEN),
          ),
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
            'Double training',
            style: TextStyle(
                fontSize: GAME_MODES_OVERVIEW_FONTSIZE.sp,
                color: Theme.of(context).colorScheme.secondary),
          ),
          onPressed: () => Navigator.of(context).pushNamed(
            '/settingsSingleDoubleTraining',
            arguments: {'mode': GameMode.DoubleTraining},
          ),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            backgroundColor: MaterialStateProperty.all(
              Utils.darken(
                  Theme.of(context).colorScheme.primary, GENERAL_DARKEN),
            ),
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
            'Single training',
            style: TextStyle(
                fontSize: GAME_MODES_OVERVIEW_FONTSIZE.sp,
                color: Theme.of(context).colorScheme.secondary),
          ),
          onPressed: () => Navigator.of(context).pushNamed(
            '/settingsSingleDoubleTraining',
            arguments: {
              'mode': GameMode.SingleTraining,
            },
          ),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            backgroundColor: MaterialStateProperty.all(
              Utils.darken(
                  Theme.of(context).colorScheme.primary, GENERAL_DARKEN),
            ),
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
            'Cricket',
            style: TextStyle(
                fontSize: GAME_MODES_OVERVIEW_FONTSIZE.sp,
                color: Theme.of(context).colorScheme.secondary),
          ),
          onPressed: () => Navigator.of(context).pushNamed('/cricket'),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            backgroundColor: MaterialStateProperty.all(
              Utils.darken(
                  Theme.of(context).colorScheme.primary, GENERAL_DARKEN),
            ),
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
            'X01',
            style: TextStyle(
                fontSize: GAME_MODES_OVERVIEW_FONTSIZE.sp,
                color: Theme.of(context).colorScheme.secondary),
          ),
          onPressed: () => Navigator.of(context).pushNamed('/settingsX01'),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            backgroundColor: MaterialStateProperty.all(
              Utils.darken(
                  Theme.of(context).colorScheme.primary, GENERAL_DARKEN),
            ),
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
    return Consumer<OpenGamesFirestore>(
        builder: (_, openGamesFirestore, __) => Container(
              width: 70.w,
              padding: EdgeInsets.only(right: 3.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Open Games: ',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    child: Text(
                      openGamesFirestore.openGames.length.toString(),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 14.sp),
                    ),
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/openGames'),
                    style: ButtonStyle(
                      splashFactory: NoSplash.splashFactory,
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      backgroundColor: MaterialStateProperty.all(
                        Utils.darken(Theme.of(context).colorScheme.primary,
                            GENERAL_DARKEN),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}
