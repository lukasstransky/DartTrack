import 'package:dart_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PointDistributionInfoSingleDoubleTraining extends StatelessWidget {
  const PointDistributionInfoSingleDoubleTraining(
      {Key? key, required this.gameMode})
      : super(key: key);

  final GameMode gameMode;

  @override
  Widget build(BuildContext context) {
    final bool isSingleTraining = gameMode == GameMode.SingleTraining;

    return Container(
      padding: EdgeInsets.only(top: 2.h, bottom: 0.5.h),
      child: Center(
        child: Column(
          children: [
            if (isSingleTraining) Item(field: 'Single', points: '1 point'),
            Item(
                field: 'Double',
                points: isSingleTraining ? '2 points' : '1 point'),
            if (isSingleTraining) Item(field: 'Tripple', points: '3 points'),
          ],
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  const Item({Key? key, required this.field, required this.points})
      : super(key: key);

  final String field;
  final String points;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      child: Row(
        children: [
          Container(
            width: 15.w,
            child: Text(
              field,
              style: TextStyle(
                color: Colors.white,
                fontSize: DEFAULT_FONT_SIZE.sp,
              ),
            ),
          ),
          Container(
            width: 5.w,
            child: Text(
              '=',
              style: TextStyle(
                color: Colors.white,
                fontSize: DEFAULT_FONT_SIZE.sp,
              ),
            ),
          ),
          Container(
            width: 20.w,
            child: Text(
              points,
              style: TextStyle(
                color: Colors.white,
                fontSize: DEFAULT_FONT_SIZE.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
