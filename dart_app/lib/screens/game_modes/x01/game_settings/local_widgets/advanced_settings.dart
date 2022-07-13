import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AdvancedSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 7.w),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () {
            Navigator.of(context).pushNamed('/inGameSettingsX01');
          },
          icon: Icon(
            Icons.settings,
          ),
          label: const Text(
            'Advanced Setttings',
          ),
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
