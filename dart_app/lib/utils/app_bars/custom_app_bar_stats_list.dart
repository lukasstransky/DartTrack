import 'package:dart_app/models/firestore/statistics_firestore_x01.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CustomAppBarStatsList extends StatefulWidget with PreferredSizeWidget {
  final String title;

  const CustomAppBarStatsList({required this.title});

  @override
  State<CustomAppBarStatsList> createState() => _CustomAppBarStatsListState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarStatsListState extends State<CustomAppBarStatsList> {
  @override
  Widget build(BuildContext context) {
    final statisticsFirestore = context.read<StatisticsFirestoreX01>();

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
