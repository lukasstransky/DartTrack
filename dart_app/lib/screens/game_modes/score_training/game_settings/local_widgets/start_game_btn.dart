import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class StartGameBtnScoreTraining extends StatelessWidget {
  const StartGameBtnScoreTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      padding: EdgeInsets.only(
        top: 20,
      ),
      child: ElevatedButton(
        onPressed: () => null,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Start Game',
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
