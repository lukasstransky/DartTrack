import 'package:dart_app/constants.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ValueTextGameStats extends StatelessWidget {
  const ValueTextGameStats({Key? key, required this.textValue})
      : super(key: key);

  final String textValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS.h),
      width: WIDTH_DATA_STATISTICS.w,
      alignment: Alignment.centerLeft,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          textValue,
          style: TextStyle(
            fontSize: FONTSIZE_STATISTICS.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
