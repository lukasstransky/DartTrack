import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CheckoutStatsCard extends StatefulWidget {
  const CheckoutStatsCard({Key? key, required this.finish, required this.game})
      : super(key: key);

  final int finish;
  final Game game;

  @override
  State<CheckoutStatsCard> createState() => _CheckoutStatsCardState();
}

class _CheckoutStatsCardState extends State<CheckoutStatsCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/statisticsX01",
            arguments: {'game': widget.game});
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.game.getGameSettings.getModeOut ==
                              SingleOrDouble.DoubleField
                          ? "Double Out"
                          : "Single Out",
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ),
                  Spacer(),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.game.getFormattedDateTime(),
                      style: TextStyle(fontSize: 10.sp),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, bottom: 10),
              child: Text(
                "Highest Finish: " + widget.finish.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
