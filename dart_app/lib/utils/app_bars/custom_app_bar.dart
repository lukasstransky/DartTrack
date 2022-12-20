import 'package:dart_app/models/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final bool showBackBtn;
  final String title;

  const CustomAppBar({this.showBackBtn = true, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showBackBtn)
            IconButton(
              onPressed: () {
                var route = ModalRoute.of(context);
                if (route != null) {
                  Navigator.of(context).pop();
                }

                if (ModalRoute.of(context)!.settings.name ==
                    '/forgotPassword') {
                  context.read<Auth>().getEmailController.clear();
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
