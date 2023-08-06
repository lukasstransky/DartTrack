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
  final bool showInfoIconSingleDoubleTraining;

  const CustomAppBar({
    this.showBackBtn = true,
    required this.title,
    this.showInfoIconScoreTraining = false,
    this.showInfoIconCricket = false,
    this.showInfoIconSingleDoubleTraining = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
        ),
      ),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showBackBtn)
            IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
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
            )
          else
            SizedBox.shrink(),
        ],
      ),
      actions: [
        if (showInfoIconScoreTraining ||
            showInfoIconCricket ||
            showInfoIconSingleDoubleTraining)
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              Utils.handleVibrationFeedback(context);
              if (showInfoIconScoreTraining) {
                AppBarDialogHelper.showInfoDialog(
                  context,
                  'Score training explained',
                  'The objective of this training is to improve your scoring. \nTo finish the game, you can either play a certain number of rounds or until a specific amount of total points is reached.',
                );
              } else if (showInfoIconCricket) {
                AppBarDialogHelper.showDialogForInfoAboutCricket(context);
              } else if (showInfoIconSingleDoubleTraining) {
                if (title == 'Single training settings') {
                  AppBarDialogHelper.showInfoDialog(
                    context,
                    'Single training explained',
                    'The objective of this training is to improve your hit rate at the single fields. \nYou can either play to hit all fields from 1 to 20 or select one specific number to hit.',
                  );
                } else {
                  AppBarDialogHelper.showInfoDialog(
                    context,
                    'Double training explained',
                    'The objective of this training is to improve your hit rate at the double fields. \nYou can either play to hit all fields from 1 to 20 or select one specific number to hit.',
                  );
                }
              }
            },
            icon: Icon(
              size: ICON_BUTTON_SIZE.h,
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

class CricketDialog extends StatefulWidget {
  @override
  _CricketDialogState createState() => _CricketDialogState();
}

class _CricketDialogState extends State<CricketDialog> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
      ),
      title: Text(
        'Cricket game from darts',
        style: TextStyle(
          fontSize: DIALOG_TITLE_FONTSIZE.sp,
        ),
      ),
      content: Container(
        width: DIALOG_WIDTH.w,
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.velocity.pixelsPerSecond.dx > 0) {
              _pageController.previousPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            } else {
              _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.5,
            child: PageView(
              controller: _pageController,
              children: [
                Container(
                  child: Text(
                    'Page 1',
                    style: TextStyle(fontSize: DIALOG_CONTENT_FONTSIZE.sp),
                  ),
                ),
                Container(
                  child: Text(
                    'Page 2',
                    style: TextStyle(fontSize: DIALOG_CONTENT_FONTSIZE.sp),
                  ),
                ),
                Container(
                  child: Text(
                    'Page 3',
                    style: TextStyle(fontSize: DIALOG_CONTENT_FONTSIZE.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            Navigator.pop(context);
          },
          child: Text(
            'Close',
            style: TextStyle(fontSize: DIALOG_BTN_FONTSIZE.sp),
          ),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            backgroundColor: Utils.getPrimaryMaterialStateColorDarken(context),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
