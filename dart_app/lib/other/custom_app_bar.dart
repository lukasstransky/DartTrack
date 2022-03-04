import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:developer';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final bool _showBackBtn;
  final String _title;

  const CustomAppBar(this._showBackBtn, this._title);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(_title),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_showBackBtn)
            IconButton(
              onPressed: () {
                var route = ModalRoute.of(context);
                if (route != null) {
                  if (route.settings.name == "/settingsX01") {
                    Navigator.of(context).pushNamed("/home");
                  } else {
                    Navigator.of(context).pop();
                  }
                }
              },
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
