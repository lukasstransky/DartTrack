import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

//ignore: must_be_immutable
class CustomAppBarWithHeart extends StatefulWidget with PreferredSizeWidget {
  CustomAppBarWithHeart(
      {required this.title,
      required this.mode,
      this.gameId,
      this.isFinishScreen = false,
      this.isFavouriteGame = false,
      this.showHeart = true});

  final String title;
  final String mode;
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

  Game_P _getGameById(String gameId, dynamic statsFirestore) {
    return statsFirestore.games.where(((g) => g.getGameId == gameId)).first;
  }

  _addGameToFavourites() {
    final dynamic statsFirestore =
        Utils.getFirestoreStatsProviderBasedOnMode(widget.mode, context);
    final String gameId =
        widget.gameId != null ? widget.gameId as String : g_gameId;

    if (widget.isFavouriteGame) {
      _changeFavouriteStateOfGame(gameId, false);

      if (!widget.isFinishScreen) {
        final Game_P game = _getGameById(gameId, statsFirestore);
        game.setIsFavouriteGame = false;

        // remove game from the favourites
        statsFirestore.favouriteGames.remove(game);
      }
    } else {
      _changeFavouriteStateOfGame(gameId, true);

      if (!widget.isFinishScreen) {
        final Game_P game = _getGameById(gameId, statsFirestore);
        game.setIsFavouriteGame = true;

        // add game to the favourites
        statsFirestore.favouriteGames.add(game);
      }
    }

    statsFirestore.notify();
  }

  _resetGame(BuildContext context) {
    if (widget.mode == 'X01') {
      context.read<GameX01_P>().reset();
    } else if (widget.mode == 'Score Training') {
      context.read<GameScoreTraining_P>().reset();
    } else if (widget.mode == 'Single Training' ||
        widget.mode == 'Double Training') {
      context.read<GameSingleDoubleTraining_P>().reset();
    }
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
      actions: [
        if (widget.showHeart)
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () async => _addGameToFavourites(),
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
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              _resetGame(context);
              Navigator.of(context).pushNamed('/home');
            },
            icon: Icon(
              Icons.home,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
      ],
    );
  }
}
