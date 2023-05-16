import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
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
      context.read<GameX01_P>().reset();
      Navigator.of(context).pushNamed(
        '/gameX01',
        arguments: {'openGame': false},
      );
    } else if (gameMode == GameMode.ScoreTraining) {
      context.read<GameScoreTraining_P>().reset();
      context.read<GameSettingsScoreTraining_P>().setInputMethod =
          InputMethod.Round;
      Navigator.of(context).pushNamed(
        '/gameScoreTraining',
        arguments: {'openGame': false},
      );
    } else if (gameMode == GameMode.SingleTraining ||
        gameMode == GameMode.DoubleTraining) {
      final game = context.read<GameSingleDoubleTraining_P>();

      game.reset();
      Navigator.of(context).pushNamed(
        '/gameSingleDoubleTraining',
        arguments: {
          'openGame': false,
          'mode': game.getName,
        },
      );
    } else if (gameMode == GameMode.Cricket) {
      context.read<GameCricket_P>().reset();
      Navigator.of(context).pushNamed(
        '/gameCricket',
        arguments: {'openGame': false},
      );
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
          onPressed: () => _newGameBtnClicked(context),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'New game',
              style: TextStyle(
                fontSize: 12.sp,
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
