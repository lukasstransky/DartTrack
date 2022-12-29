import 'package:dart_app/models/auth.dart';
import 'package:dart_app/utils/app_bars/app_bar_dialog_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final bool showBackBtn;
  final String title;
  final bool showInfoIcon;

  const CustomAppBar(
      {this.showBackBtn = true,
      required this.title,
      this.showInfoIcon = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
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
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).colorScheme.secondary,
              ),
            )
          else
            SizedBox.shrink(),
        ],
      ),
      actions: [
        if (showInfoIcon)
          IconButton(
              onPressed: () =>
                  AppBarDialogHelper.showDialogForInfoAboutScoreTraining(
                      context),
              icon: Icon(
                Icons.info_outline,
                color: Theme.of(context).colorScheme.secondary,
              )),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
