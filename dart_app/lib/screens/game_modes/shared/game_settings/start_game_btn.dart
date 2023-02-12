import 'package:dart_app/constants.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class StartGameBtn extends StatelessWidget {
  const StartGameBtn({Key? key, required this.mode}) : super(key: key);

  final GameMode mode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      padding: EdgeInsets.only(top: 10),
      child: ElevatedButton(
        onPressed: () {
          if (mode == GameMode.ScoreTraining) {
            Navigator.of(context).pushNamed(
              '/gameScoreTraining',
              arguments: {
                'openGame': false,
                'mode': mode,
              },
            );
          } else if (mode == GameMode.SingleTraining ||
              mode == GameMode.DoubleTraining) {
            Navigator.of(context).pushNamed(
              '/gameSingleDoubleTraining',
              arguments: {
                'openGame': false,
                'mode': mode == GameMode.SingleTraining
                    ? 'Single training'
                    : 'Double training',
              },
            );
          }
        },
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Start game',
            style: TextStyle(
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
                  Radius.circular(10),
                ),
              ),
            ),
            backgroundColor: Utils.getPrimaryMaterialStateColorDarken(context)),
      ),
    );
  }
}
