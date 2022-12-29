import 'package:dart_app/constants.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';

class AppBarDialogHelper {
  static showDialogForInfoAboutScoreTraining(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding: EdgeInsets.only(
            bottom: DIALOG_CONTENT_PADDING_BOTTOM,
            top: DIALOG_CONTENT_PADDING_TOP,
            left: DIALOG_CONTENT_PADDING_LEFT,
            right: DIALOG_CONTENT_PADDING_RIGHT),
        title: Text(
          'Score Training explained',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        content: Text(
          'The objective of this training is to improve your scoring. To finish the game, you can either play a certain number of rounds or until a specific amount of total points is reached.',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Continue',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            style: ButtonStyle(
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
            ),
          ),
        ],
      ),
    );
  }
}
