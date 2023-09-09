import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/screens/game_modes/shared/game/revert_btn.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ThrownDarts extends StatelessWidget {
  const ThrownDarts({Key? key, required this.mode}) : super(key: key);

  final GameMode mode;

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (mode == GameMode.ScoreTraining) {
      widget = Selector<GameScoreTraining_P, List<String>>(
        selector: (_, game) => game.getCurrentThreeDarts,
        shouldRebuild: (previous, next) => true,
        builder: (_, currentThreeDarts, __) => ThrownDartsWidget(
          currentThreeDarts: currentThreeDarts,
          mode: mode,
        ),
      );
    } else if (mode == GameMode.SingleTraining ||
        mode == GameMode.DoubleTraining) {
      widget = Selector<GameSingleDoubleTraining_P, List<String>>(
        selector: (_, game) => game.getCurrentThreeDarts,
        shouldRebuild: (previous, next) => true,
        builder: (_, currentThreeDarts, __) => ThrownDartsWidget(
          currentThreeDarts: currentThreeDarts,
          mode: mode,
        ),
      );
    } else if (mode == GameMode.Cricket) {
      widget = Selector<GameCricket_P, List<String>>(
        selector: (_, game) => game.getCurrentThreeDarts,
        shouldRebuild: (previous, next) => true,
        builder: (_, currentThreeDarts, __) => ThrownDartsWidget(
          currentThreeDarts: currentThreeDarts,
          mode: mode,
        ),
      );
    } else {
      return SizedBox.shrink();
    }

    return Container(
      height: THROWN_DARTS_WIDGET_HEIGHT.h,
      child: widget,
    );
  }
}

class ThrownDartsWidget extends StatelessWidget {
  const ThrownDartsWidget({
    Key? key,
    required this.currentThreeDarts,
    required this.mode,
  }) : super(key: key);

  final List<String> currentThreeDarts;
  final GameMode mode;

  @override
  Widget build(BuildContext context) {
    final dynamic gameProvider =
        Utils.getGameProviderBasedOnMode(mode, context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (mode == GameMode.SingleTraining || mode == GameMode.DoubleTraining)
          Expanded(
            child: Selector<GameSingleDoubleTraining_P, bool>(
              selector: (_, game) => game.getRevertPossible,
              builder: (_, revertPossible, __) =>
                  RevertBtn(game_p: context.read<GameSingleDoubleTraining_P>()),
            ),
          ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: GENERAL_BORDER_WIDTH.w,
                ),
                left: Utils.isLandscape(context)
                    ? BorderSide(
                        color: Utils.getPrimaryColorDarken(context),
                        width: GENERAL_BORDER_WIDTH.w,
                      )
                    : BorderSide.none,
                top: BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: GENERAL_BORDER_WIDTH.w,
                ),
              ),
            ),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(
                    Utils.darken(Theme.of(context).colorScheme.primary, 20)),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: FittedBox(
                child: Text(
                  currentThreeDarts[0],
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: () {
                null;
              },
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: GENERAL_BORDER_WIDTH.w,
                ),
              ),
            ),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(
                    Utils.darken(Theme.of(context).colorScheme.primary, 20)),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: FittedBox(
                child: Text(
                  currentThreeDarts[1],
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: () {
                null;
              },
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: GENERAL_BORDER_WIDTH.w,
                ),
                left: BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: GENERAL_BORDER_WIDTH.w,
                ),
                right: gameProvider.getSafeAreaPadding.right > 0
                    ? BorderSide(
                        color: Utils.getPrimaryColorDarken(context),
                        width: GENERAL_BORDER_WIDTH.w,
                      )
                    : BorderSide.none,
              ),
            ),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(
                    Utils.darken(Theme.of(context).colorScheme.primary, 20)),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: FittedBox(
                child: Text(
                  currentThreeDarts[2],
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: () {
                null;
              },
            ),
          ),
        ),
      ],
    );
  }
}
