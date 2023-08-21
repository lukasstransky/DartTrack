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
      padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS.h),
      transform: Matrix4.translationValues(-2.5.w, 0.0, 0.0),
      child: Text(
        textValue,
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
          color: Colors.white,
        ),
      ),
    );
  }
}
