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
      this.isFavouriteGame = false,
      this.showHeart = true});

  final String title;
  final String? gameId; // optional, passed from game.statistics
  final bool isFinishScreen;
  final bool showHeart;
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

  _addGameToFavourites() {
    final StatisticsFirestoreX01 statisticsFirestoreX01 =
        context.read<StatisticsFirestoreX01>();
    final String gameId =
        widget.gameId != null ? widget.gameId as String : g_gameId;

    if (widget.isFavouriteGame) {
      _changeFavouriteStateOfGame(gameId, false);

      if (!widget.isFinishScreen) {
        final Game game = _getGameById(gameId, statisticsFirestoreX01);
        game.setIsFavouriteGame = false;

        // remove game from the favourites
        statisticsFirestoreX01.favouriteGames.remove(game);
      }
    } else {
      _changeFavouriteStateOfGame(gameId, true);

      if (!widget.isFinishScreen) {
        final Game game = _getGameById(gameId, statisticsFirestoreX01);
        game.setIsFavouriteGame = true;

        // add game to the favourites
        statisticsFirestoreX01.favouriteGames.add(game);
      }
    }

    statisticsFirestoreX01.notify();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
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
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
      actions: [
        if (widget.showHeart)
          IconButton(
            onPressed: () async => {
              _addGameToFavourites(),
            },
            icon: widget.isFavouriteGame
                ? Icon(
                    MdiIcons.heart,
                    color: Theme.of(context).colorScheme.secondary,
                  )
                : Icon(
                    MdiIcons.heartOutline,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
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
