import 'package:dart_app/utils/app_bars/app_bar_dialog_helper.dart';
import 'package:flutter/material.dart';

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
        style: TextStyle(color: Colors.white),
      ),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showBackBtn)
            IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                var route = ModalRoute.of(context);
                if (route != null) {
                  Navigator.of(context).pop();
                }
              },
              icon: Icon(
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
      title: Text('Cricket Game from Darts'),
      content: GestureDetector(
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
                child: Text('Page 1'),
              ),
              Container(
                child: Text('Page 2'),
              ),
              Container(
                child: Text('Page 3'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
