import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomChip extends StatelessWidget {
  final Widget label;
  final Color color;

  const CustomChip({
    Key? key,
    required this.label,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.8.h),
      decoration: BoxDecoration(
        color: this.color,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: this.color, width: 1),
      ),
      child: label,
    );
  }
}
