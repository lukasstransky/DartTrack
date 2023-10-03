import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/models/game_settings/game_settings_single_double_training_p.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class NewGameBtn extends StatelessWidget {
  const NewGameBtn({
    Key? key,
    required this.gameMode,
  }) : super(key: key);

  final GameMode gameMode;

  _newGameBtnClicked(BuildContext context) async {
    if (gameMode == GameMode.X01) {
      context.read<GameX01_P>().init(context.read<GameSettingsX01_P>());
      Navigator.of(context).pushNamed('/gameX01');
    } else if (gameMode == GameMode.ScoreTraining) {
      final GameSettingsScoreTraining_P gameSettingsScoreTraining =
          context.read<GameSettingsScoreTraining_P>();
      gameSettingsScoreTraining.setInputMethod = InputMethod.Round;
      context.read<GameScoreTraining_P>().init(gameSettingsScoreTraining);

      Navigator.of(context).pushNamed('/gameScoreTraining');
    } else if (gameMode == GameMode.SingleTraining ||
        gameMode == GameMode.DoubleTraining) {
      final GameSingleDoubleTraining_P gameSingleDoubleTraining =
          context.read<GameSingleDoubleTraining_P>();

      gameSingleDoubleTraining.init(
        context.read<GameSettingsSingleDoubleTraining_P>(),
        gameSingleDoubleTraining.getMode,
      );
      Navigator.of(context).pushNamed(
        '/gameSingleDoubleTraining',
        arguments: {
          'mode': gameSingleDoubleTraining.getName,
        },
      );
    } else if (gameMode == GameMode.Cricket) {
      context.read<GameCricket_P>().init(context.read<GameSettingsCricket_P>());
      Navigator.of(context).pushNamed('/gameCricket');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Container(
        width: 40.w,
        height: 6.h,
        child: ElevatedButton(
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            _newGameBtnClicked(context);
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'New game',
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          style: ButtonStyle(
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
            backgroundColor: Utils.getPrimaryMaterialStateColorDarken(context),
          ),
        ),
      ),
    );
  }
}
