import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/firestore/x01/statistics_firestore_x01_p.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AutoSubmitOrScoredPointsSwitch extends StatefulWidget {
  const AutoSubmitOrScoredPointsSwitch({Key? key}) : super(key: key);

  @override
  State<AutoSubmitOrScoredPointsSwitch> createState() =>
      _AutoSubmitOrScoredPointsSwitchState();
}

class _AutoSubmitOrScoredPointsSwitchState
    extends State<AutoSubmitOrScoredPointsSwitch> {
  final GlobalKey<FormState> _formKeyMostScoredPoint = GlobalKey<FormState>();
  TextEditingController? _mostScoredPointController;

  @override
  void initState() {
    super.initState();
    _checkIfAtLeastOneX01GameIsPlayed();
  }

  // for "fetch from stats" btn for most scored points
  _checkIfAtLeastOneX01GameIsPlayed() async {
    await context
        .read<FirestoreServiceGames>()
        .checkIfAtLeastOneX01GameIsPlayed(context);
  }

  _showDialogForMostScoredPointInput(
      BuildContext context, GameSettingsX01_P gameSettingsX01, int i) {
    _mostScoredPointController = new TextEditingController(
        text: gameSettingsX01.getMostScoredPoints[i].toString());

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Form(
        key: _formKeyMostScoredPoint,
        child: AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary,
          contentPadding: EdgeInsets.only(
              bottom: DIALOG_CONTENT_PADDING_BOTTOM,
              top: DIALOG_CONTENT_PADDING_TOP,
              left: DIALOG_CONTENT_PADDING_LEFT,
              right: DIALOG_CONTENT_PADDING_RIGHT),
          title: const Text(
            'Enter Value',
            style: TextStyle(color: Colors.white),
          ),
          content: Container(
            margin: EdgeInsets.only(left: 20.w, right: 20.w),
            child: TextFormField(
              controller: _mostScoredPointController,
              validator: (value) {
                if (value!.isEmpty) {
                  return ('Please enter a value!');
                }
                if (int.parse(value) > 180) {
                  return ('Maximal value is 180!');
                }
                if (gameSettingsX01.getMostScoredPoints.contains(value)) {
                  return ('Value is already defined!');
                }

                return null;
              },
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Value',
                fillColor:
                    Utils.darken(Theme.of(context).colorScheme.primary, 10),
                filled: true,
                hintStyle: TextStyle(
                  color: Utils.getPrimaryColorDarken(context),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              style: ButtonStyle(
                backgroundColor:
                    Utils.getPrimaryMaterialStateColorDarken(context),
              ),
            ),
            TextButton(
              onPressed: () =>
                  _submitMostScoredPoint(context, i, gameSettingsX01),
              child: Text(
                'Submit',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              style: ButtonStyle(
                backgroundColor:
                    Utils.getPrimaryMaterialStateColorDarken(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _submitMostScoredPoint(
      BuildContext context, int i, GameSettingsX01_P gameSettingsX01) {
    if (!_formKeyMostScoredPoint.currentState!.validate()) {
      return;
    }
    _formKeyMostScoredPoint.currentState!.save();

    gameSettingsX01.getMostScoredPoints[i] = _mostScoredPointController!.text;
    gameSettingsX01.notify();
    Navigator.of(context).pop();
    _mostScoredPointController!.clear();
  }

  int _calcCardHeight(GameSettingsX01_P gameSettingsX01,
      StatisticsFirestoreX01_P statisticsFirestoreX01) {
    if (gameSettingsX01.getInputMethod == InputMethod.Round &&
        gameSettingsX01.getShowMostScoredPoints) {
      if (!statisticsFirestoreX01.noGamesPlayed) {
        return 27;
      } else {
        return 21;
      }
    }

    return 6;
  }

  _fetchFromStatsBtnPressed(GameSettingsX01_P gameSettingsX01,
      StatisticsFirestoreX01_P statisticsFirestoreX01) {
    for (int i = 0; i < gameSettingsX01.getMostScoredPoints.length; i++) {
      if (i < statisticsFirestoreX01.preciseScores.length)
        gameSettingsX01.getMostScoredPoints[i] =
            statisticsFirestoreX01.preciseScores.keys.elementAt(i).toString();
    }

    for (int i = 0; i < gameSettingsX01.getMostScoredPoints.length; i++) {
      for (int j = 0; j < gameSettingsX01.getMostScoredPoints.length; j++) {
        if (i != j &&
            gameSettingsX01.getMostScoredPoints[i] ==
                gameSettingsX01.getMostScoredPoints[j]) {
          gameSettingsX01.getMostScoredPoints[j] =
              DEFAULT_MOST_SCORED_POINTS[j];
        }
      }
    }

    gameSettingsX01.notify();
  }

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 = context.read<GameSettingsX01_P>();
    final statisticsFirestore = context.read<StatisticsFirestoreX01_P>();
    final showMostScoredPoints = gameSettingsX01.getShowMostScoredPoints;

    return Container(
      height: _calcCardHeight(gameSettingsX01, statisticsFirestore).h,
      child: Column(
        children: [
          getSubmitPointsOrShowPointsSwitch(gameSettingsX01),
          if (gameSettingsX01.getInputMethod == InputMethod.Round &&
              showMostScoredPoints) ...[
            Selector<GameSettingsX01_P, List<String>>(
              selector: (_, gameSettingsX01) =>
                  gameSettingsX01.getMostScoredPoints,
              shouldRebuild: (previous, next) => true,
              builder: (_, mostScoredPoints, __) => Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        for (int i = 0; i < mostScoredPoints.length; i += 2)
                          mostScoredPointValue(gameSettingsX01, i),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        for (int i = 1; i < mostScoredPoints.length; i += 2)
                          mostScoredPointValue(gameSettingsX01, i),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!statisticsFirestore.noGamesPlayed)
              fetchFromStatsBtn(gameSettingsX01, statisticsFirestore),
          ],
        ],
      ),
    );
  }

  Container fetchFromStatsBtn(GameSettingsX01_P gameSettingsX01,
      StatisticsFirestoreX01_P statisticsFirestoreX01) {
    return Container(
      height: 4.h,
      margin: EdgeInsets.only(top: 5.w, left: 5.w, right: 5.w),
      alignment: Alignment.centerLeft,
      child: ElevatedButton(
        child: Text(
          'Fetch from statistics',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        onPressed: () => {
          _fetchFromStatsBtnPressed(gameSettingsX01, statisticsFirestoreX01),
        },
        style: ButtonStyle(
          backgroundColor: Utils.getPrimaryMaterialStateColorDarken(context),
          splashFactory: NoSplash.splashFactory,
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
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

  Container mostScoredPointValue(GameSettingsX01_P gameSettingsX01, int i) {
    return Container(
      width: 25.w,
      padding:
          (i == 2 || i == 3) ? EdgeInsets.only(top: 1.h, bottom: 1.h) : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 4.h,
            width: 6.w,
            child: Center(
              child: Text(
                '${i + 1}.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              height: 4.h,
              child: ElevatedButton(
                child: Text(
                  gameSettingsX01.getMostScoredPoints[i],
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () => _showDialogForMostScoredPointInput(
                    context, gameSettingsX01, i),
                style: ButtonStyle(
                  splashFactory: NoSplash.splashFactory,
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      side: BorderSide(
                        color: Utils.getPrimaryColorDarken(context),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
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

  Flexible getSubmitPointsOrShowPointsSwitch(
      GameSettingsX01_P gameSettingsX01) {
    if (gameSettingsX01.getInputMethod == InputMethod.Round) {
      return Flexible(
        child: Padding(
          padding: EdgeInsets.only(left: 2.5.w),
          child: Row(
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Most Scored Points',
                  style: TextStyle(
                      fontSize: FONTSIZE_IN_GAME_SETTINGS.sp,
                      color: Colors.white),
                ),
              ),
              Spacer(),
              Switch(
                value: gameSettingsX01.getShowMostScoredPoints,
                onChanged: (value) {
                  gameSettingsX01.setShowMostScoredPoints = value;

                  gameSettingsX01.notify();
                },
                thumbColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.secondary),
                activeColor: Theme.of(context).colorScheme.secondary,
                inactiveThumbColor: Theme.of(context).colorScheme.secondary,
              ),
            ],
          ),
        ),
      );
    } else {
      return Flexible(
        child: Padding(
          padding: EdgeInsets.only(left: 2.5.w),
          child: Row(
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Automatically Submit Points',
                  style: TextStyle(
                      fontSize: FONTSIZE_IN_GAME_SETTINGS.sp,
                      color: Colors.white),
                ),
              ),
              Spacer(),
              Selector<GameSettingsX01_P, bool>(
                selector: (_, gameSettingsX01) =>
                    gameSettingsX01.getAutomaticallySubmitPoints,
                builder: (_, automaticallySubmitPoints, __) => Switch(
                  value: automaticallySubmitPoints,
                  onChanged: (value) {
                    gameSettingsX01.setAutomaticallySubmitPoints = value;

                    gameSettingsX01.notify();
                  },
                  thumbColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.secondary),
                  activeColor: Theme.of(context).colorScheme.secondary,
                  inactiveThumbColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
