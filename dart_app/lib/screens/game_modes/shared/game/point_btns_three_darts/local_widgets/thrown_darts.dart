import 'package:dart_app/models/games/score_training/game_score_training_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ThrownDarts extends StatelessWidget {
  const ThrownDarts({Key? key, required this.mode}) : super(key: key);

  final String mode;

  @override
  Widget build(BuildContext context) {
    if (mode == 'Score Training')
      return Selector<GameScoreTraining_P, List<String>>(
        selector: (_, gameScoreTraining_P) =>
            gameScoreTraining_P.getCurrentThreeDarts,
        shouldRebuild: (previous, next) => true,
        builder: (_, currentThreeDarts, __) =>
            ThrownDartsWidget(currentThreeDarts: currentThreeDarts),
      );

    return SizedBox.shrink();
  }
}

class ThrownDartsWidget extends StatelessWidget {
  const ThrownDartsWidget({
    Key? key,
    required this.currentThreeDarts,
  }) : super(key: key);

  final List<String> currentThreeDarts;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: 3,
                ),
                top: BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: 3,
                ),
              ),
            ),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(
                    Utils.darken(Theme.of(context).colorScheme.primary, 20)),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: FittedBox(
                child: Text(
                  currentThreeDarts[0],
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: () {
                null;
              },
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: 3,
                ),
              ),
            ),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(
                    Utils.darken(Theme.of(context).colorScheme.primary, 20)),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: FittedBox(
                child: Text(
                  currentThreeDarts[1],
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: () {
                null;
              },
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: 3,
                ),
                left: BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: 3,
                ),
              ),
            ),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(
                    Utils.darken(Theme.of(context).colorScheme.primary, 20)),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: FittedBox(
                child: Text(
                  currentThreeDarts[2],
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: () {
                null;
              },
            ),
          ),
        ),
      ],
    );
  }
}
