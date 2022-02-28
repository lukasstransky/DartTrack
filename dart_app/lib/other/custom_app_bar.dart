import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String _leadingIcon;
  final String _title;

  const CustomAppBar(this._leadingIcon, this._title);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(_title),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_leadingIcon == "back")
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back),
            )
          else
            Container(),
        ],
      ),
      actions: [],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
