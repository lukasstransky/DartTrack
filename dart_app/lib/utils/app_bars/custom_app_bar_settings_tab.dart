import 'package:flutter/material.dart';

class CustomAppBarSettingsTab extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBarSettingsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text('Settings',
          style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleSmall!.fontSize)),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
