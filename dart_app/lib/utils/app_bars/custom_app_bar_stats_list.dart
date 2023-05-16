import 'package:dart_app/constants.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sizer/sizer.dart';

class CustomAppBarStatsList extends StatefulWidget with PreferredSizeWidget {
  final String title;
  final GameMode mode;

  const CustomAppBarStatsList({required this.title, required this.mode});

  @override
  State<CustomAppBarStatsList> createState() => _CustomAppBarStatsListState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarStatsListState extends State<CustomAppBarStatsList> {
  @override
  Widget build(BuildContext context) {
    final dynamic statisticsFirestore =
        Utils.getFirestoreStatsProviderBasedOnMode(widget.mode, context);

    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Column(
        children: [
          Text(
            widget.title,
            style: TextStyle(fontSize: 14.sp),
          ),
        ],
      ),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              var route = ModalRoute.of(context);
              if (route != null) {
                Navigator.of(context).pop();
              }
            },
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () => {
            if (statisticsFirestore.showFavouriteGames)
              {
                setState(() {
                  statisticsFirestore.showFavouriteGames = false;
                  statisticsFirestore.notify();
                }),
              }
            else
              {
                setState(() {
                  statisticsFirestore.showFavouriteGames = true;
                  statisticsFirestore.notify();
                }),
              }
          },
          icon: statisticsFirestore.showFavouriteGames
              ? Icon(
                  MdiIcons.heart,
                  color: Theme.of(context).colorScheme.secondary,
                )
              : Icon(
                  MdiIcons.heartOutline,
                  color: Theme.of(context).colorScheme.secondary,
                ),
        ),
      ],
    );
  }
}
