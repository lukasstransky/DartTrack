import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01.dart';
import 'package:dart_app/models/games/x01/helper/submit_helper.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/round/point_btn_round.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/revert_btn.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/select_input_method.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/submit_points_btn.dart';
import 'package:dart_app/screens/game_modes/x01/shared.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PointsBtnsRound extends StatelessWidget {
  PointsBtnsRound({Key? key}) : super(key: key);

  // deletes one char of the points
  _deleteCurrentPointsSelected(BuildContext context, GameX01 gameX01) {
    gameX01.setCurrentPointsSelected = gameX01.getCurrentPointsSelected
        .substring(0, gameX01.getCurrentPointsSelected.length - 1);

    if (gameX01.getCurrentPointsSelected.isEmpty) {
      gameX01.setCurrentPointsSelected = 'Points';
    }

    gameX01.notify();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<GameX01, GameSettingsX01_P>(
      builder: (_, gameX01, gameSettingsX01, __) => Expanded(
        child: Column(
          children: [
            Container(
              height: 6.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 25.w,
                    child: RevertBtn(),
                  ),
                  Container(
                    width: 50.w,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            width: 3,
                            color: Utils.getPrimaryColorDarken(context),
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          gameX01.getCurrentPointsSelected,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Utils.getTextColorDarken(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 25.w,
                    child: SubmitPointsBtn(),
                  ),
                ],
              ),
            ),
            if (gameX01.getGameSettings.getShowInputMethodInGameScreen)
              SelectInputMethod(),
            firstRow(gameX01),
            secondRow(gameX01),
            thirdRow(gameX01),
            fourthRow(gameX01, context),
          ],
        ),
      ),
    );
  }

  Expanded firstRow(GameX01 gameX01) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (gameX01.getGameSettings.getShowMostScoredPoints)
            Expanded(
              child: gameX01.shouldPointBtnBeDisabled(
                      gameX01.getGameSettings.getMostScoredPoints[0])
                  ? PointBtnRound(
                      point: gameX01.getGameSettings.getMostScoredPoints[0],
                      activeBtn: false,
                      mostScoredPointBtn: true)
                  : PointBtnRound(
                      point: gameX01.getGameSettings.getMostScoredPoints[0],
                      activeBtn: true,
                      mostScoredPointBtn: true),
            ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('1')
                ? PointBtnRound(
                    point: '1', activeBtn: false, mostScoredPointBtn: false)
                : PointBtnRound(
                    point: '1', activeBtn: true, mostScoredPointBtn: false),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('2')
                ? PointBtnRound(
                    point: '2', activeBtn: false, mostScoredPointBtn: false)
                : PointBtnRound(
                    point: '2', activeBtn: true, mostScoredPointBtn: false),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('3')
                ? PointBtnRound(
                    point: '3', activeBtn: false, mostScoredPointBtn: false)
                : PointBtnRound(
                    point: '3', activeBtn: true, mostScoredPointBtn: false),
          ),
          if (gameX01.getGameSettings.getShowMostScoredPoints)
            Expanded(
              child: gameX01.shouldPointBtnBeDisabled(
                      gameX01.getGameSettings.getMostScoredPoints[1])
                  ? PointBtnRound(
                      point: gameX01.getGameSettings.getMostScoredPoints[1],
                      activeBtn: false,
                      mostScoredPointBtn: true)
                  : PointBtnRound(
                      point: gameX01.getGameSettings.getMostScoredPoints[1],
                      activeBtn: true,
                      mostScoredPointBtn: true),
            ),
        ],
      ),
    );
  }

  Expanded secondRow(GameX01 gameX01) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (gameX01.getGameSettings.getShowMostScoredPoints)
            Expanded(
              child: gameX01.shouldPointBtnBeDisabled(
                      gameX01.getGameSettings.getMostScoredPoints[2])
                  ? PointBtnRound(
                      point: gameX01.getGameSettings.getMostScoredPoints[2],
                      activeBtn: false,
                      mostScoredPointBtn: true)
                  : PointBtnRound(
                      point: gameX01.getGameSettings.getMostScoredPoints[2],
                      activeBtn: true,
                      mostScoredPointBtn: true),
            ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('4')
                ? PointBtnRound(
                    point: '4', activeBtn: false, mostScoredPointBtn: false)
                : PointBtnRound(
                    point: '4', activeBtn: true, mostScoredPointBtn: false),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('5')
                ? PointBtnRound(
                    point: '5', activeBtn: false, mostScoredPointBtn: false)
                : PointBtnRound(
                    point: '5', activeBtn: true, mostScoredPointBtn: false),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('6')
                ? PointBtnRound(
                    point: '6', activeBtn: false, mostScoredPointBtn: false)
                : PointBtnRound(
                    point: '6', activeBtn: true, mostScoredPointBtn: false),
          ),
          if (gameX01.getGameSettings.getShowMostScoredPoints)
            Expanded(
              child: gameX01.shouldPointBtnBeDisabled(
                      gameX01.getGameSettings.getMostScoredPoints[3])
                  ? PointBtnRound(
                      point: gameX01.getGameSettings.getMostScoredPoints[3],
                      activeBtn: false,
                      mostScoredPointBtn: true)
                  : PointBtnRound(
                      point: gameX01.getGameSettings.getMostScoredPoints[3],
                      activeBtn: true,
                      mostScoredPointBtn: true),
            ),
        ],
      ),
    );
  }

  Expanded thirdRow(GameX01 gameX01) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (gameX01.getGameSettings.getShowMostScoredPoints)
            Expanded(
              child: gameX01.shouldPointBtnBeDisabled(
                      gameX01.getGameSettings.getMostScoredPoints[4])
                  ? PointBtnRound(
                      point: gameX01.getGameSettings.getMostScoredPoints[4],
                      activeBtn: false,
                      mostScoredPointBtn: true)
                  : PointBtnRound(
                      point: gameX01.getGameSettings.getMostScoredPoints[4],
                      activeBtn: true,
                      mostScoredPointBtn: true),
            ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('7')
                ? PointBtnRound(
                    point: '7', activeBtn: false, mostScoredPointBtn: false)
                : PointBtnRound(
                    point: '7', activeBtn: true, mostScoredPointBtn: false),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('8')
                ? PointBtnRound(
                    point: '8', activeBtn: false, mostScoredPointBtn: false)
                : PointBtnRound(
                    point: '8', activeBtn: true, mostScoredPointBtn: false),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('9')
                ? PointBtnRound(
                    point: '9', activeBtn: false, mostScoredPointBtn: false)
                : PointBtnRound(
                    point: '9', activeBtn: true, mostScoredPointBtn: false),
          ),
          if (gameX01.getGameSettings.getShowMostScoredPoints)
            Expanded(
              child: gameX01.shouldPointBtnBeDisabled(
                      gameX01.getGameSettings.getMostScoredPoints[5])
                  ? PointBtnRound(
                      point: gameX01.getGameSettings.getMostScoredPoints[5],
                      activeBtn: false,
                      mostScoredPointBtn: true)
                  : PointBtnRound(
                      point: gameX01.getGameSettings.getMostScoredPoints[5],
                      activeBtn: true,
                      mostScoredPointBtn: true),
            ),
        ],
      ),
    );
  }

  Expanded fourthRow(GameX01 gameX01, BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    backgroundColor:
                        gameX01.getCurrentPointsSelected == 'Points'
                            ? MaterialStateProperty.all(Utils.darken(
                                Theme.of(context).colorScheme.primary, 25))
                            : MaterialStateProperty.all(
                                Theme.of(context).colorScheme.primary),
                    overlayColor: gameX01.getCurrentPointsSelected == 'Points'
                        ? MaterialStateProperty.all(Colors.transparent)
                        : Utils.getDefaultOverlayColor(context)),
                child: Icon(
                  FeatherIcons.delete,
                  size: 30.sp,
                  color: Utils.getTextColorDarken(context),
                ),
                onPressed: () {
                  if (gameX01.getCurrentPointsSelected != 'Points') {
                    _deleteCurrentPointsSelected(context, gameX01);
                  }
                }),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('0')
                ? PointBtnRound(
                    point: '0', activeBtn: false, mostScoredPointBtn: false)
                : PointBtnRound(
                    point: '0', activeBtn: true, mostScoredPointBtn: false),
          ),
          Expanded(
            child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  backgroundColor: gameX01.getCurrentPointsSelected == 'Points'
                      ? MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary)
                      : MaterialStateProperty.all(Utils.darken(
                          Theme.of(context).colorScheme.primary, 25)),
                  overlayColor: gameX01.getCurrentPointsSelected == 'Points'
                      ? Utils.getColorOrPressed(
                          Theme.of(context).colorScheme.primary,
                          Utils.darken(
                              Theme.of(context).colorScheme.primary, 15),
                        )
                      : MaterialStateProperty.all(Colors.transparent),
                ),
                child: Text(
                  'Bust',
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                    color: Utils.getTextColorDarken(context),
                  ),
                ),
                onPressed: () {
                  if (gameX01.getCurrentPointsSelected != 'Points') {
                    return;
                  }

                  if (gameX01.getGameSettings.getEnableCheckoutCounting &&
                      gameX01.isCheckoutPossible()) {
                    final int count =
                        gameX01.getAmountOfCheckoutPossibilities('0');

                    if (count != -1) {
                      showDialogForCheckout(count, '0', context);
                    } else {
                      Submit.bust(context);
                    }
                  } else {
                    Submit.bust(context);
                  }
                }),
          ),
        ],
      ),
    );
  }
}
