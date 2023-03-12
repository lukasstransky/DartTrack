import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CheckoutStatsCard extends StatefulWidget {
  const CheckoutStatsCard({Key? key, required this.finish, required this.game})
      : super(key: key);

  final int finish;
  final GameX01_P game;

  @override
  State<CheckoutStatsCard> createState() => _CheckoutStatsCardState();
}

class _CheckoutStatsCardState extends State<CheckoutStatsCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/statisticsX01',
            arguments: {'game': widget.game});
      },
      child: Card(
        color: Utils.darken(Theme.of(context).colorScheme.primary, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 5,
                left: 10,
                right: 10,
                bottom: 5,
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
                left: 10,
                bottom: 5,
              ),
              child: Text(
                'Highest finish: ' + widget.finish.toString(),
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
