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
    final double _fontSizeDateTime = Utils.getResponsiveValue(
      context: context,
      mobileValue: 10,
      tabletValue: 8,
    );
    final double _fontSizeField = Utils.getResponsiveValue(
      context: context,
      mobileValue: 14,
      tabletValue: 12,
    );

    return Container(
      padding: EdgeInsets.only(bottom: 2.h),
      child: GestureDetector(
        onTap: () {
          Utils.handleVibrationFeedback(context);
          Navigator.pushNamed(context, '/statisticsX01',
              arguments: {'game': widget.game});
        },
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
                        widget.game.getGameSettings.getModeOut ==
                                ModeOutIn.Double
                            ? 'Double out'
                            : 'Single out',
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyMedium!.fontSize,
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
                          fontSize: _fontSizeDateTime.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 2.w,
                  bottom: 0.5.h,
                ),
                child: Text(
                  '${widget.isWorstFinished ? 'Worst' : 'Best'} finish: ${widget.finish.toString()}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: _fontSizeField.sp,
                    color: Utils.getTextColorDarken(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
