import 'package:dart_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SectionHeadingGameStats extends StatelessWidget {
  const SectionHeadingGameStats({
    Key? key,
    required this.textValue,
  }) : super(key: key);

  final String textValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
      padding: EdgeInsets.only(top: 1.h),
      child: Text(
        textValue,
        style: TextStyle(
          fontSize: FONTSIZE_HEADING_STATISTICS.sp,
          color: Colors.white,
        ),
      ),
    );
  }
}
