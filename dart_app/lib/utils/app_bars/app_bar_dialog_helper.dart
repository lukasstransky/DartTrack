import 'package:dart_app/constants.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AppBarDialogHelper {
  static showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding:
            Utils.isMobile(context) ? DIALOG_CONTENT_PADDING_MOBILE : null,
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
          ),
        ),
        content: Text(
          content,
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Utils.handleVibrationFeedback(context);
              Navigator.of(context).pop();
            },
            child: Text(
              'Close',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static showDialogForInfoAboutCricket(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => CricketDialog(),
    );
  }
}

class CricketDialog extends StatefulWidget {
  @override
  _CricketDialogState createState() => _CricketDialogState();
}

class _CricketDialogState extends State<CricketDialog> {
  final PageController _pageController = PageController(initialPage: 0);
  final int _amountOfPages = 5;

  @override
  Widget build(BuildContext context) {
    final double dialogHeight = 28;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
      ),
      contentPadding:
          Utils.isMobile(context) ? DIALOG_CONTENT_PADDING_MOBILE : null,
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(
        'Cricket explained',
        style: TextStyle(
          color: Colors.white,
          fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
        ),
      ),
      content: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.velocity.pixelsPerSecond.dx > 0) {
            _pageController.previousPage(
              duration: Duration(milliseconds: 100),
              curve: Curves.easeOut,
            );
          } else {
            _pageController.nextPage(
              duration: Duration(milliseconds: 100),
              curve: Curves.easeOut,
            );
          }
        },
        child: SizedBox(
          width: 80.w,
          height: dialogHeight.h,
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 1.h),
                          Text(
                            'Goal',
                            style: TextStyle(
                              color: Utils.getTextColorDarken(context),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'In Cricket, the objective is opening or closing the numbers 15 till 20 as well as the bullseye. \nIn standard mode, the player with the highest score wins, but it is also possible to play two additional modes (Cut throat, No score), which are also explained here.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .fontSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 1.h),
                          Text(
                            'Scoring points',
                            style: TextStyle(
                              color: Utils.getTextColorDarken(context),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .fontSize,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      'In order to score points, a number has to be ',
                                ),
                                TextSpan(
                                  text: 'opened',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      '. A player opens a number by hitting it three times with any combination of singles, doubles, or triples. \nOnce open, further hits on the number score points equal to it\'s value, until the number is closed.',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 1.h),
                          Text(
                            'Close number',
                            style: TextStyle(
                              color: Utils.getTextColorDarken(context),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .fontSize,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'A number is ',
                                ),
                                TextSpan(
                                  text: 'closed ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text:
                                      'when all players have hit the number three times, so it is not possible anymore to score any points with that number.',
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 1.h),
                          Text(
                            'Cut throat',
                            style: TextStyle(
                              color: Utils.getTextColorDarken(context),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'For this mode, the same basic rules apply as for the standard mode, but when points are scored for an open number, instead the points are given to all other players.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .fontSize,
                            ),
                          ),
                          Text(
                            'The player with the lowest number of points at the end wins the game.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .fontSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 1.h),
                          Text(
                            'No score',
                            style: TextStyle(
                              color: Utils.getTextColorDarken(context),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'For this mode, if a number is open, no points are given for any additional hits on that number. Therefore, the goal is closing the numbers as fast as possible, and the first player who manages to do that also wins the game.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .fontSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SmoothPageIndicator(
                controller: _pageController,
                count: _amountOfPages,
                effect: ExpandingDotsEffect(
                  dotColor: Colors.grey,
                  activeDotColor: Colors.white,
                  dotHeight: 8.0,
                  dotWidth: 8.0,
                  expansionFactor: 2,
                  spacing: 8.0,
                ),
              ),
            ],
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
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
            ),
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
