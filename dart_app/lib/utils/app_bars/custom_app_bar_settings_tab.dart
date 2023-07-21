import 'package:dart_app/models/settings_p.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CustomAppBarSettingsTab extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBarSettingsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String appVersion = context.read<Settings_P>().getVersion;

    return AppBar(
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Column(
        children: [
          Text(
            'Settings',
            style: TextStyle(fontSize: 14.sp),
          ),
          Text(
            appVersion,
            style: TextStyle(fontSize: 10.sp),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
