import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/statistics_firestore_x01.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
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
      BuildContext context, GameSettingsX01 gameSettingsX01, int i) {
    _mostScoredPointController = new TextEditingController(
        text: gameSettingsX01.getMostScoredPoints[i].toString());

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Form(
        key: _formKeyMostScoredPoint,
        child: AlertDialog(
          contentPadding: EdgeInsets.only(
              bottom: DIALOG_CONTENT_PADDING_BOTTOM,
              top: DIALOG_CONTENT_PADDING_TOP,
              left: DIALOG_CONTENT_PADDING_LEFT,
              right: DIALOG_CONTENT_PADDING_RIGHT),
          title: const Text('Enter Value'),
          content: Container(
            margin: EdgeInsets.only(left: 10.w, right: 10.w),
            child: TextFormField(
              controller: _mostScoredPointController,
              validator: (value) {
                if (value!.isEmpty) return ('Please enter a value!');

                if (int.parse(value) > 180) return ('Maximal value is 180!');

                if (gameSettingsX01.getMostScoredPoints.contains(value))
                  return ('Value is already defined!');

                return null;
              },
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  _submitMostScoredPoint(context, i, gameSettingsX01),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  _submitMostScoredPoint(
      BuildContext context, int i, GameSettingsX01 gameSettingsX01) {
    if (!_formKeyMostScoredPoint.currentState!.validate()) {
      return;
    }
    _formKeyMostScoredPoint.currentState!.save();

    gameSettingsX01.getMostScoredPoints[i] = _mostScoredPointController!.text;
    gameSettingsX01.notify();
    Navigator.of(context).pop();
    _mostScoredPointController!.clear();
  }

  int _calcCardHeight(GameSettingsX01 gameSettingsX01,
      StatisticsFirestoreX01 statisticsFirestoreX01) {
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

  _fetchFromStatsBtnPressed(GameSettingsX01 gameSettingsX01,
      StatisticsFirestoreX01 statisticsFirestoreX01) {
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
    final gameSettingsX01 = context.read<GameSettingsX01>();
    final statisticsFirestore = context.read<StatisticsFirestoreX01>();
    final showMostScoredPoints = gameSettingsX01.getShowMostScoredPoints;

    return Container(
      height: _calcCardHeight(gameSettingsX01, statisticsFirestore).h,
      child: Column(
        children: [
          getSubmitPointsOrShowPointsSwitch(gameSettingsX01),
          if (gameSettingsX01.getInputMethod == InputMethod.Round &&
              showMostScoredPoints) ...[
            Selector<GameSettingsX01, List<String>>(
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

  Container fetchFromStatsBtn(GameSettingsX01 gameSettingsX01,
      StatisticsFirestoreX01 statisticsFirestoreX01) {
    return Container(
      height: 4.h,
      margin: EdgeInsets.only(top: 5.w, left: 5.w, right: 5.w),
      alignment: Alignment.centerLeft,
      child: ElevatedButton(
        child: Text('Fetch from Stats'),
        onPressed: () => {
          _fetchFromStatsBtnPressed(gameSettingsX01, statisticsFirestoreX01),
        },
        style: ButtonStyle(
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

  Container mostScoredPointValue(GameSettingsX01 gameSettingsX01, int i) {
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
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              height: 4.h,
              child: ElevatedButton(
                child: Text(gameSettingsX01.getMostScoredPoints[i]),
                onPressed: () => _showDialogForMostScoredPointInput(
                    context, gameSettingsX01, i),
                style: ButtonStyle(
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
          ),
        ],
      ),
    );
  }

  Flexible getSubmitPointsOrShowPointsSwitch(GameSettingsX01 gameSettingsX01) {
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
                  style: TextStyle(fontSize: FONTSIZE_IN_GAME_SETTINGS.sp),
                ),
              ),
              Spacer(),
              Switch(
                value: gameSettingsX01.getShowMostScoredPoints,
                onChanged: (value) {
                  gameSettingsX01.setShowMostScoredPoints = value;

                  gameSettingsX01.notify();
                },
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
                  style: TextStyle(fontSize: FONTSIZE_IN_GAME_SETTINGS.sp),
                ),
              ),
              Spacer(),
              Selector<GameSettingsX01, bool>(
                selector: (_, gameSettingsX01) =>
                    gameSettingsX01.getAutomaticallySubmitPoints,
                builder: (_, automaticallySubmitPoints, __) => Switch(
                  value: automaticallySubmitPoints,
                  onChanged: (value) {
                    gameSettingsX01.setAutomaticallySubmitPoints = value;

                    gameSettingsX01.notify();
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
