import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CheckoutStatsCard extends StatefulWidget {
  const CheckoutStatsCard(
      {Key? key,
      required this.finish,
      required this.game,
      required this.isWorstFinished})
      : super(key: key);

  final int finish;
  final GameX01_P game;
  final bool isWorstFinished;

  @override
  State<CheckoutStatsCard> createState() => _CheckoutStatsCardState();
}

class _CheckoutStatsCardState extends State<CheckoutStatsCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/statisticsX01',
          arguments: {'game': widget.game}),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CARD_SHAPE_ROUNDING),
        ),
        color: Utils.darken(Theme.of(context).colorScheme.primary, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 0.5.h,
                left: 2.5.w,
                right: 2.5.w,
                bottom: 0.5.h,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.game.getGameSettings.getModeOut == ModeOutIn.Double
                          ? 'Double Out'
                          : 'Single Out',
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
                      widget.game.getFormattedDateTime(),
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
              padding: EdgeInsets.only(
                left: 1.h,
                bottom: 0.5.h,
              ),
              child: Text(
                '${widget.isWorstFinished ? 'Worst' : 'Best'} finish: ${widget.finish.toString()}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color: Utils.getTextColorDarken(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
