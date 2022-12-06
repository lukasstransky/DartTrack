import 'package:dart_app/constants.dart';
import 'package:dart_app/models/firestore/statistics_firestore_x01.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

//ignore: must_be_immutable
class CustomAppBarWithHeart extends StatefulWidget with PreferredSizeWidget {
  CustomAppBarWithHeart(
      {required this.title,
      this.gameId,
      this.isFinishScreen = false,
      this.isFavouriteGame = false});

  final String title;
  final String? gameId; // optional, passed from game.statistics
  final bool isFinishScreen;
  bool isFavouriteGame;

  @override
  State<CustomAppBarWithHeart> createState() => _CustomAppBarWithHeartState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarWithHeartState extends State<CustomAppBarWithHeart> {
  _changeFavouriteStateOfGame(String gameId, bool state) async {
    await context
        .read<FirestoreServiceGames>()
        .changeFavouriteStateOfGame(gameId, state);

    setState(() {
      widget.isFavouriteGame = state;
    });
  }

  Game _getGameById(
      String gameId, StatisticsFirestoreX01 statisticsFirestoreX01) {
    return statisticsFirestoreX01.games
        .where(((g) => g.getGameId == gameId))
        .first;
  }

  _showDialogForFavouriteGame(BuildContext context) {
    final StatisticsFirestoreX01 statisticsFirestoreX01 =
        context.read<StatisticsFirestoreX01>();
    final String gameId =
        widget.gameId != null ? widget.gameId as String : g_gameId;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.only(
            bottom: DIALOG_CONTENT_PADDING_BOTTOM,
            top: DIALOG_CONTENT_PADDING_TOP,
            left: DIALOG_CONTENT_PADDING_LEFT,
            right: DIALOG_CONTENT_PADDING_RIGHT),
        title: Text(widget.isFavouriteGame
            ? 'Remove from favourite games'
            : 'Add to favourite games'),
        content: Text(widget.isFavouriteGame
            ? 'Do you want to remove this game from your favourites?'
            : 'Do you want to add this game to your favourites?'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              if (widget.isFavouriteGame) {
                _changeFavouriteStateOfGame(gameId, false);

                if (!widget.isFinishScreen) {
                  final Game game =
                      _getGameById(gameId, statisticsFirestoreX01);
                  game.setIsFavouriteGame = false;

                  // remove game from the favourites
                  statisticsFirestoreX01.favouriteGames.remove(game);
                }
              } else {
                _changeFavouriteStateOfGame(gameId, true);

                if (!widget.isFinishScreen) {
                  final Game game =
                      _getGameById(gameId, statisticsFirestoreX01);
                  game.setIsFavouriteGame = true;

                  // add game to the favourites
                  statisticsFirestoreX01.favouriteGames.add(game);
                }
              }

              statisticsFirestoreX01.notify();
              Navigator.of(context).pop();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text(widget.title),
      leading: widget.isFinishScreen
          ? SizedBox.shrink()
          : IconButton(
              onPressed: () {
                var route = ModalRoute.of(context);
                if (route != null) {
                  Navigator.of(context).pop();
                }
              },
              icon: Icon(Icons.arrow_back),
            ),
      actions: [
        IconButton(
          onPressed: () async => {
            _showDialogForFavouriteGame(context),
          },
          icon: widget.isFavouriteGame
              ? Icon(MdiIcons.heart)
              : Icon(MdiIcons.heartOutline),
        ),
        if (widget.isFinishScreen)
          IconButton(
            onPressed: () => {
              Navigator.of(context).pushNamed('/home'),
            },
            icon: Icon(
              Icons.home,
            ),
          ),
      ],
    );
  }
}
