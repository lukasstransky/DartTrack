import 'package:dart_app/constants.dart';
import 'package:dart_app/utils/app_bars/app_bar_dialog_helper.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackBtn;
  final String title;
  final bool showInfoIconScoreTraining;
  final bool showInfoIconCricket;
  final GameMode gameMode;

  const CustomAppBar({
    this.showBackBtn = true,
    required this.title,
    this.showInfoIconScoreTraining = false,
    this.showInfoIconCricket = false,
    this.gameMode = GameMode.None,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
        ),
      ),
      leading: showBackBtn
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  splashColor:
                      Utils.darken(Theme.of(context).colorScheme.primary, 10),
                  splashRadius: SPLASH_RADIUS,
                  highlightColor:
                      Utils.darken(Theme.of(context).colorScheme.primary, 10),
                  onPressed: () {
                    Utils.handleVibrationFeedback(context);
                    var route = ModalRoute.of(context);
                    if (route != null) {
                      Navigator.of(context).pop();
                    }
                  },
                  icon: Icon(
                    size: ICON_BUTTON_SIZE.h,
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            )
          : null,
      actions: [
        (showInfoIconScoreTraining ||
                showInfoIconCricket ||
                gameMode != GameMode.None)
            ? IconButton(
                splashColor:
                    Utils.darken(Theme.of(context).colorScheme.primary, 10),
                splashRadius: SPLASH_RADIUS,
                highlightColor:
                    Utils.darken(Theme.of(context).colorScheme.primary, 10),
                onPressed: () {
                  Utils.handleVibrationFeedback(context);
                  if (showInfoIconScoreTraining) {
                    AppBarDialogHelper.showInfoDialog(
                      context,
                      'Score training explained',
                      'The objective of this training is to improve your scoring. \nTo finish the game, you can either play a certain number of rounds, or until a specific amount of total points is reached.',
                    );
                  } else if (showInfoIconCricket) {
                    AppBarDialogHelper.showDialogForInfoAboutCricket(context);
                  } else if (gameMode != GameMode.None) {
                    if (gameMode == GameMode.SingleTraining) {
                      AppBarDialogHelper.showInfoDialog(
                        context,
                        'Single training explained',
                        'The objective of this training is to improve your hit rate at the single fields. \nYou can either play to hit all fields from 1 to 20, or select one specific number to hit.',
                      );
                    } else {
                      AppBarDialogHelper.showInfoDialog(
                        context,
                        'Double training explained',
                        'The objective of this training is to improve your hit rate at the double fields. \nYou can either play to hit all fields from 1 to 20, or select one specific number to hit.',
                      );
                    }
                  }
                },
                icon: Icon(
                  size: ICON_BUTTON_SIZE.h,
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            : IconButton(
                splashColor:
                    Utils.darken(Theme.of(context).colorScheme.primary, 10),
                splashRadius: SPLASH_RADIUS,
                highlightColor:
                    Utils.darken(Theme.of(context).colorScheme.primary, 10),
                onPressed: null,
                icon: Icon(
                  size: 0,
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
