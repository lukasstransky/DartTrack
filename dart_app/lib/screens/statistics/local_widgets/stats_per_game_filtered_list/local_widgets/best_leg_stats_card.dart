import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BestLegStatsCard extends StatelessWidget {
  const BestLegStatsCard(
      {Key? key,
      required this.bestLeg,
      required this.game,
      required this.isWorstSelected})
      : super(key: key);

  final int bestLeg;
  final GameX01_P game;
  final bool isWorstSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 2.h),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/statisticsX01',
            arguments: {'game': game}),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CARD_SHAPE_ROUNDING),
          ),
          color: Utils.darken(Theme.of(context).colorScheme.primary, 10),
          margin: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 1.h,
                  left: 2.w,
                  right: 2.w,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        Utils.getBestOfOrFirstToString(game.getGameSettings),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Spacer(),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        game.getFormattedDateTime(),
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.w),
                child: Text(game.getGameSettings.getGameModeDetails(true),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 2.w,
                  bottom: 0.5.h,
                ),
                child: Text(
                  '${isWorstSelected ? 'Worst' : 'Best'} leg: ${bestLeg}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: Utils.getTextColorDarken(context),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
