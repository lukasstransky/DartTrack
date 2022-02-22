import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final bool _showBackBtn;
  final String _title;

  const CustomAppBar(this._showBackBtn, this._title);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(_title),
      leading: _showBackBtn == true
          ? IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back))
          : Container(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
