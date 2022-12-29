import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/score_training/game_settings_score_training_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ModeScoreTraining extends StatelessWidget {
  const ModeScoreTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameSettingsScoreTraining_P =
        context.read<GameSettingsScoreTraining_P>();

    return Center(
      child: Container(
        width: WIDTH_GAMESETTINGS.w,
        height: WIDGET_HEIGHT_GAMESETTINGS.h,
        child: Selector<GameSettingsScoreTraining_P, ScoreTrainingModeEnum>(
          selector: (_, gameSettingsScoreTraining_P) =>
              gameSettingsScoreTraining_P.getMode,
          builder: (_, scoreTrainingModeEnum, __) => Row(
            children: [
              Btn(
                condition: gameSettingsScoreTraining_P.getMode ==
                    ScoreTrainingModeEnum.MaxRounds,
                text: 'max. Rounds',
                isLeftBtn: true,
              ),
              Btn(
                condition: gameSettingsScoreTraining_P.getMode ==
                    ScoreTrainingModeEnum.MaxPoints,
                text: 'max. Points',
                isLeftBtn: false,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Btn extends StatelessWidget {
  const Btn(
      {Key? key,
      required this.condition,
      required this.text,
      required this.isLeftBtn})
      : super(key: key);

  final bool condition;
  final String text;
  final bool isLeftBtn;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () =>
            context.read<GameSettingsScoreTraining_P>().switchMode(),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: TextStyle(
              color: Utils.getTextColorForGameSettingsBtn(condition, context),
            ),
          ),
        ),
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              side: BorderSide(
                color: Utils.getPrimaryColorDarken(context),
                width: GAME_SETTINGS_BTN_BORDER_WITH,
              ),
              borderRadius: BorderRadius.only(
                topLeft: isLeftBtn
                    ? Radius.circular(BUTTON_BORDER_RADIUS)
                    : Radius.zero,
                bottomLeft: isLeftBtn
                    ? Radius.circular(BUTTON_BORDER_RADIUS)
                    : Radius.zero,
                topRight: !isLeftBtn
                    ? Radius.circular(BUTTON_BORDER_RADIUS)
                    : Radius.zero,
                bottomRight: !isLeftBtn
                    ? Radius.circular(BUTTON_BORDER_RADIUS)
                    : Radius.zero,
              ),
            ),
          ),
          backgroundColor: condition
              ? Utils.getPrimaryMaterialStateColorDarken(context)
              : Utils.getColor(Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
