import 'package:dart_app/constants.dart';
import 'package:dart_app/models/firestore/stats_firestore_x01_p.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class FetchFromStatsBtn extends StatelessWidget {
  const FetchFromStatsBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StatsFirestoreX01_P statisticsFirestore =
        context.read<StatsFirestoreX01_P>();
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();
    final bool fetchFromStatsBtnClickable = !statisticsFirestore.noGamesPlayed;

    return Row(
      children: [
        Container(
          transform: Matrix4.translationValues(0.0, 1.0.h, 0.0),
          child: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              Utils.handleVibrationFeedback(context);
              _showInfoDialogForFetchFromStatsBtn(context);
            },
            icon: Icon(
              size: ICON_BUTTON_SIZE.h,
              Icons.info_outline,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            top: 2.h,
            right: 3.w,
          ),
          child: ElevatedButton(
            child: Container(
              alignment: Alignment.center,
              height: 4.h,
              child: Text(
                'Fetch from stats',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                ),
              ),
            ),
            onPressed: () {
              Utils.handleVibrationFeedback(context);
              if (!fetchFromStatsBtnClickable) {
                Fluttertoast.showToast(
                  msg: 'No games played!',
                  toastLength: Toast.LENGTH_LONG,
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                );
              }
              _fetchFromStatsBtnPressed(gameSettingsX01, statisticsFirestore);
            },
            style: ButtonStyle(
              backgroundColor: fetchFromStatsBtnClickable
                  ? Utils.getPrimaryMaterialStateColorDarken(context)
                  : Utils.getColor(
                      Utils.darken(Theme.of(context).colorScheme.primary, 60)),
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
        ),
      ],
    );
  }
}

_fetchFromStatsBtnPressed(GameSettingsX01_P gameSettingsX01,
    StatsFirestoreX01_P statisticsFirestoreX01) {
  final sortedPreciseScores =
      Utils.sortMapIntIntByKey(statisticsFirestoreX01.preciseScores);

  for (int i = 0; i < gameSettingsX01.getMostScoredPoints.length; i++) {
    if (i < sortedPreciseScores.length)
      gameSettingsX01.getMostScoredPoints[i] =
          sortedPreciseScores.keys.elementAt(i).toString();
  }

  for (int i = 0; i < gameSettingsX01.getMostScoredPoints.length; i++) {
    for (int j = 0; j < gameSettingsX01.getMostScoredPoints.length; j++) {
      if (i != j &&
          gameSettingsX01.getMostScoredPoints[i] ==
              gameSettingsX01.getMostScoredPoints[j]) {
        gameSettingsX01.getMostScoredPoints[j] = DEFAULT_MOST_SCORED_POINTS[j];
      }
    }
  }

  gameSettingsX01.notify();
}

_showInfoDialogForFetchFromStatsBtn(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      contentPadding:
          Utils.isMobile(context) ? DIALOG_CONTENT_PADDING_MOBILE : null,
      title: Container(
        width: TEXT_DIALOG_WIDTH.w,
        child: Text(
          'Information',
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
          ),
        ),
      ),
      content: Container(
        width: DIALOG_NORMAL_WIDTH.w,
        child: Text(
          'By clicking this button, the top six most frequently scored points from all of your games will be loaded into the \'most scored points\' fields.',
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            Navigator.of(context).pop();
          },
          child: Text(
            'Continue',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
            ),
          ),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            backgroundColor: Utils.getPrimaryMaterialStateColorDarken(context),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
