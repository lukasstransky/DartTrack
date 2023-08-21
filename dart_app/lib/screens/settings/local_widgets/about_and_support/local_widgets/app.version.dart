import 'package:dart_app/models/settings_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String appVersion = context.read<Settings_P>().getVersion;

    return Material(
      color: Colors.transparent,
      child: Container(
        height: 4.h,
        child: Container(
          height: 4.h,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: Utils.getColor(
                Utils.darken(Theme.of(context).colorScheme.primary, 10),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              elevation: MaterialStateProperty.all(0),
            ),
            onPressed: null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 1.w),
                  child: Text(
                    'Version',
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium!.fontSize,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  appVersion,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
