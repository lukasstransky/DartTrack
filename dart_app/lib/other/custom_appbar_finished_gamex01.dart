import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CustomAppBarGameX01Finished extends StatelessWidget
    with PreferredSizeWidget {
  CustomAppBarGameX01Finished(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text(title),
      actions: [
        IconButton(
          onPressed: () => null, //todo -> add game to favorites
          icon: Icon(MdiIcons.heartOutline),
        ),
        IconButton(
            onPressed: () => Navigator.of(context).pushNamed("/home"),
            icon: Icon(
              Icons.home,
            )),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
