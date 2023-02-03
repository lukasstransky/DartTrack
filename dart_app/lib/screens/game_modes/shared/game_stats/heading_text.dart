import 'package:dart_app/constants.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HeadingTextGameStats extends StatelessWidget {
  const HeadingTextGameStats({Key? key, required this.textValue})
      : super(key: key);

  final String textValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: WIDTH_HEADINGS_STATISTICS.w,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          textValue,
          style: TextStyle(
            fontSize: FONTSIZE_STATISTICS.sp,
            color: Utils.getTextColorDarken(context),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
