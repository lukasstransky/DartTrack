import 'package:dart_app/constants.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AppBarDialogHelper {
  static showDialogForInfoAboutScoreTraining(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding: dialogContentPadding,
        title: Text(
          'Score training explained',
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
              'Close',
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
    return AlertDialog(
      contentPadding: dialogContentPadding,
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(
        'Cricket explained',
        style: TextStyle(
          color: Colors.white,
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
          height: 28.h,
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
                              fontSize: 12.sp,
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
                          Text(
                            'In order to score points, a number has to be "opened". A player opens a number by hitting it three times with any combination of singles, doubles, or triples. \nOnce open, further hits on the number score points equal to it\'s value, until it\'s closed.',
                            style: TextStyle(color: Colors.white),
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
                          Text(
                            'A number is "closed" when all players have hit the number three times, so it is not possible anymore to score any points with that number.',
                            style: TextStyle(
                              color: Colors.white,
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
                            ),
                          ),
                          Text(
                            'The player with the lowest number of points at the end wins the game.',
                            style: TextStyle(
                              color: Colors.white,
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
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Close',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: Utils.getPrimaryMaterialStateColorDarken(context),
          ),
        ),
      ],
    );
  }
}
