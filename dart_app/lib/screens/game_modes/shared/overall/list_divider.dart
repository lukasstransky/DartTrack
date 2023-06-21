import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ListDivider extends StatelessWidget {
  const ListDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
        height: 2.h,
        thickness: 1,
        endIndent: 10,
        indent: 10,
        color: Utils.getTextColorDarken(context));
  }
}
