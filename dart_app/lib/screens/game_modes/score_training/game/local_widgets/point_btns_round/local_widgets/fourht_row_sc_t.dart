import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/screens/game_modes/score_training/game/local_widgets/point_btns_round/local_widgets/point_btn_round_sc_t.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class FourthRowBtnsRoundScoreTraining extends StatelessWidget {
  const FourthRowBtnsRoundScoreTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: DeleteBtn(),
          ),
          Expanded(
            child: PointBtnRoundScoreTraining(
              point: '0',
            ),
          ),
          Expanded(
            child: SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class DeleteBtn extends StatelessWidget {
  const DeleteBtn({Key? key}) : super(key: key);

  // deletes one char of the points
  _deleteCurrentPointsSelected(
      BuildContext context, GameScoreTraining_P gameScoreTraining_P) {
    gameScoreTraining_P.setCurrentPointsSelected = gameScoreTraining_P
        .getCurrentPointsSelected
        .substring(0, gameScoreTraining_P.getCurrentPointsSelected.length - 1);

    if (gameScoreTraining_P.getCurrentPointsSelected.isEmpty) {
      gameScoreTraining_P.setCurrentPointsSelected = 'Points';
    }

    gameScoreTraining_P.notify();
  }

  @override
  Widget build(BuildContext context) {
    final gameScoreTraining_P = context.read<GameScoreTraining_P>();
    final double _deleteIconSize = Utils.getResponsiveValue(
      context: context,
      mobileValue: 25,
      tabletValue: 20,
    );

    return Selector<GameScoreTraining_P, String>(
      selector: (_, gameScoreTraining_P) =>
          gameScoreTraining_P.getCurrentPointsSelected,
      builder: (_, currentPointsSelected, __) => Container(
        decoration: BoxDecoration(
          border: Border(
            left: Utils.isLandscape(context)
                ? BorderSide(
                    width: GENERAL_BORDER_WIDTH.w,
                    color: Utils.getPrimaryColorDarken(context),
                  )
                : BorderSide.none,
            bottom:
                context.read<GameScoreTraining_P>().getSafeAreaPadding.bottom >
                        0
                    ? BorderSide(
                        width: GENERAL_BORDER_WIDTH.w,
                        color: Utils.getPrimaryColorDarken(context),
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
              backgroundColor: currentPointsSelected == 'Points'
                  ? MaterialStateProperty.all(
                      Utils.darken(Theme.of(context).colorScheme.primary, 25),
                    )
                  : MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary),
              overlayColor: currentPointsSelected == 'Points'
                  ? MaterialStateProperty.all(Colors.transparent)
                  : Utils.getDefaultOverlayColor(context),
            ),
            child: Icon(
              FeatherIcons.delete,
              size: _deleteIconSize.sp,
              color: Utils.getTextColorDarken(context),
            ),
            onPressed: () {
              Utils.handleVibrationFeedback(context);
              if (currentPointsSelected != 'Points') {
                _deleteCurrentPointsSelected(context, gameScoreTraining_P);
              }
            }),
      ),
    );
  }
}
