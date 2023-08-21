import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/games/x01/helper/submit_x01_helper.dart';
import 'package:dart_app/screens/game_modes/shared/game/revert_btn.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/round/point_btn_round_x01.dart';
import 'package:dart_app/screens/game_modes/shared/select_input_method/select_input_method.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/submit_points_btn_x01.dart';
import 'package:dart_app/screens/game_modes/x01/shared.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PointBtnsRoundX01 extends StatelessWidget {
  PointBtnsRoundX01({Key? key}) : super(key: key);

  // deletes one char of the points
  _deleteCurrentPointsSelected(BuildContext context, GameX01_P gameX01) {
    gameX01.setCurrentPointsSelected = gameX01.getCurrentPointsSelected
        .substring(0, gameX01.getCurrentPointsSelected.length - 1);

    if (gameX01.getCurrentPointsSelected.isEmpty) {
      gameX01.setCurrentPointsSelected = 'Points';
    }

    gameX01.notify();
  }

  @override
  Widget build(BuildContext context) {
    final GameX01_P gameX01 = context.read<GameX01_P>();
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();
    final double _fontSizeCurrentPoints = Utils.getResponsiveValue(
      context: context,
      mobileValue: 20,
      tabletValue: 18,
      otherValue: 18,
    );

    return Expanded(
      child: Selector<GameSettingsX01_P, SelectorModel>(
        selector: (_, gameSettingsX01) => SelectorModel(
          showInputMethodInGameScreen:
              gameSettingsX01.getShowInputMethodInGameScreen,
          showMostScoredPoints: gameSettingsX01.getShowMostScoredPoints,
        ),
        builder: (_, selectorModel, __) => Selector<GameX01_P, String>(
          selector: (_, gameX01) => gameX01.getCurrentPointsSelected,
          builder: (_, currentPointsSelected, __) => Column(
            children: [
              Container(
                height: 6.h,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 25.w,
                      child: RevertBtn(game_p: gameX01),
                    ),
                    Container(
                      width: 50.w,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width: GENERAL_BORDER_WIDTH.w,
                              color: Utils.getPrimaryColorDarken(context),
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            currentPointsSelected,
                            style: TextStyle(
                              fontSize: _fontSizeCurrentPoints.sp,
                              fontWeight: FontWeight.bold,
                              color: Utils.getTextColorDarken(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 25.w,
                      child: SubmitPointsBtnX01(),
                    ),
                  ],
                ),
              ),
              if (selectorModel.showInputMethodInGameScreen)
                SelectInputMethod(mode: GameMode.X01),
              firstRow(
                gameX01,
                gameSettingsX01,
                selectorModel.showMostScoredPoints,
              ),
              secondRow(
                gameX01,
                gameSettingsX01,
                selectorModel.showMostScoredPoints,
              ),
              thirdRow(
                gameX01,
                gameSettingsX01,
                selectorModel.showMostScoredPoints,
              ),
              fourthRow(gameX01, context),
            ],
          ),
        ),
      ),
    );
  }

  Expanded firstRow(GameX01_P gameX01, GameSettingsX01_P gameSettingsX01,
      bool showMostScoredPoints) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showMostScoredPoints)
            Expanded(
              child: gameX01.shouldPointBtnBeDisabled(
                      gameSettingsX01.getMostScoredPoints[0])
                  ? PointBtnRoundX01(
                      point: gameSettingsX01.getMostScoredPoints[0],
                      activeBtn: false,
                      mostScoredPointBtn: true)
                  : PointBtnRoundX01(
                      point: gameSettingsX01.getMostScoredPoints[0],
                      activeBtn: true,
                      mostScoredPointBtn: true),
            ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('1')
                ? PointBtnRoundX01(
                    point: '1', activeBtn: false, mostScoredPointBtn: false)
                : PointBtnRoundX01(
                    point: '1', activeBtn: true, mostScoredPointBtn: false),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('2')
                ? PointBtnRoundX01(
                    point: '2', activeBtn: false, mostScoredPointBtn: false)
                : PointBtnRoundX01(
                    point: '2', activeBtn: true, mostScoredPointBtn: false),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('3')
                ? PointBtnRoundX01(
                    point: '3', activeBtn: false, mostScoredPointBtn: false)
                : PointBtnRoundX01(
                    point: '3', activeBtn: true, mostScoredPointBtn: false),
          ),
          if (showMostScoredPoints)
            Expanded(
              child: gameX01.shouldPointBtnBeDisabled(
                      gameSettingsX01.getMostScoredPoints[1])
                  ? PointBtnRoundX01(
                      point: gameSettingsX01.getMostScoredPoints[1],
                      activeBtn: false,
                      mostScoredPointBtn: true)
                  : PointBtnRoundX01(
                      point: gameSettingsX01.getMostScoredPoints[1],
                      activeBtn: true,
                      mostScoredPointBtn: true),
            ),
        ],
      ),
    );
  }

  Expanded secondRow(GameX01_P gameX01, GameSettingsX01_P gameSettingsX01,
      bool showMostScoredPoints) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showMostScoredPoints)
            Expanded(
              child: gameX01.shouldPointBtnBeDisabled(
                      gameSettingsX01.getMostScoredPoints[2])
                  ? PointBtnRoundX01(
                      point: gameSettingsX01.getMostScoredPoints[2],
                      activeBtn: false,
                      mostScoredPointBtn: true)
                  : PointBtnRoundX01(
                      point: gameSettingsX01.getMostScoredPoints[2],
                      activeBtn: true,
                      mostScoredPointBtn: true),
            ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('4')
                ? PointBtnRoundX01(
                    point: '4', activeBtn: false, mostScoredPointBtn: false)
                : PointBtnRoundX01(
                    point: '4', activeBtn: true, mostScoredPointBtn: false),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('5')
                ? PointBtnRoundX01(
                    point: '5', activeBtn: false, mostScoredPointBtn: false)
                : PointBtnRoundX01(
                    point: '5', activeBtn: true, mostScoredPointBtn: false),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('6')
                ? PointBtnRoundX01(
                    point: '6', activeBtn: false, mostScoredPointBtn: false)
                : PointBtnRoundX01(
                    point: '6', activeBtn: true, mostScoredPointBtn: false),
          ),
          if (showMostScoredPoints)
            Expanded(
              child: gameX01.shouldPointBtnBeDisabled(
                      gameSettingsX01.getMostScoredPoints[3])
                  ? PointBtnRoundX01(
                      point: gameSettingsX01.getMostScoredPoints[3],
                      activeBtn: false,
                      mostScoredPointBtn: true)
                  : PointBtnRoundX01(
                      point: gameSettingsX01.getMostScoredPoints[3],
                      activeBtn: true,
                      mostScoredPointBtn: true),
            ),
        ],
      ),
    );
  }

  Expanded thirdRow(GameX01_P gameX01, GameSettingsX01_P gameSettingsX01,
      bool showMostScoredPoints) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showMostScoredPoints)
            Expanded(
              child: gameX01.shouldPointBtnBeDisabled(
                      gameSettingsX01.getMostScoredPoints[4])
                  ? PointBtnRoundX01(
                      point: gameSettingsX01.getMostScoredPoints[4],
                      activeBtn: false,
                      mostScoredPointBtn: true)
                  : PointBtnRoundX01(
                      point: gameSettingsX01.getMostScoredPoints[4],
                      activeBtn: true,
                      mostScoredPointBtn: true),
            ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('7')
                ? PointBtnRoundX01(
                    point: '7', activeBtn: false, mostScoredPointBtn: false)
                : PointBtnRoundX01(
                    point: '7', activeBtn: true, mostScoredPointBtn: false),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('8')
                ? PointBtnRoundX01(
                    point: '8', activeBtn: false, mostScoredPointBtn: false)
                : PointBtnRoundX01(
                    point: '8', activeBtn: true, mostScoredPointBtn: false),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('9')
                ? PointBtnRoundX01(
                    point: '9', activeBtn: false, mostScoredPointBtn: false)
                : PointBtnRoundX01(
                    point: '9', activeBtn: true, mostScoredPointBtn: false),
          ),
          if (showMostScoredPoints)
            Expanded(
              child: gameX01.shouldPointBtnBeDisabled(
                      gameSettingsX01.getMostScoredPoints[5])
                  ? PointBtnRoundX01(
                      point: gameSettingsX01.getMostScoredPoints[5],
                      activeBtn: false,
                      mostScoredPointBtn: true)
                  : PointBtnRoundX01(
                      point: gameSettingsX01.getMostScoredPoints[5],
                      activeBtn: true,
                      mostScoredPointBtn: true),
            ),
        ],
      ),
    );
  }

  Expanded fourthRow(GameX01_P gameX01, BuildContext context) {
    final double _fontSize = Utils.getResponsiveValue(
      context: context,
      mobileValue: 25,
      tabletValue: 20,
      otherValue: 20,
    );

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
                  size: _fontSize.sp,
                  color: Utils.getTextColorDarken(context),
                ),
                onPressed: () {
                  if (gameX01.getCurrentPointsSelected != 'Points') {
                    Utils.handleVibrationFeedback(context);
                    _deleteCurrentPointsSelected(context, gameX01);
                  }
                }),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('0')
                ? PointBtnRoundX01(
                    point: '0', activeBtn: false, mostScoredPointBtn: false)
                : PointBtnRoundX01(
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
                    fontSize: _fontSize.sp,
                    fontWeight: FontWeight.bold,
                    color: Utils.getTextColorDarken(context),
                  ),
                ),
                onPressed: () {
                  if (gameX01.getCurrentPointsSelected != 'Points') {
                    return;
                  }
                  Utils.handleVibrationFeedback(context);
                  if (gameX01.getGameSettings.getEnableCheckoutCounting &&
                      gameX01.isCheckoutPossible()) {
                    final int count =
                        gameX01.getAmountOfCheckoutPossibilities('0');

                    if (count != -1) {
                      showDialogForCheckout(count, '0', context);
                    } else {
                      SubmitX01Helper.bust(context);
                    }
                  } else {
                    SubmitX01Helper.bust(context);
                  }
                }),
          ),
        ],
      ),
    );
  }
}

class SelectorModel {
  final bool showInputMethodInGameScreen;
  final bool showMostScoredPoints;

  SelectorModel({
    required this.showInputMethodInGameScreen,
    required this.showMostScoredPoints,
  });
}
