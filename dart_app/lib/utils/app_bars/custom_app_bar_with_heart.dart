import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

//ignore: must_be_immutable
class CustomAppBarWithHeart extends StatefulWidget
    implements PreferredSizeWidget {
  CustomAppBarWithHeart(
      {required this.title,
      required this.mode,
      this.gameId,
      this.isFinishScreen = false,
      this.isFavouriteGame = false,
      this.showHeart = true});

  final String title;
  final GameMode mode;
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
  @override
  void initState() {
    super.initState();
    if (widget.gameId != null && widget.gameId!.isNotEmpty) {
      final dynamic statsFirestore =
          Utils.getFirestoreStatsProviderBasedOnMode(widget.mode, context);

      for (dynamic game in statsFirestore.games) {
        if (game.getGameId == widget.gameId) {
          widget.isFavouriteGame = game.getIsFavouriteGame;
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String username =
        context.read<AuthService>().getUsernameFromSharedPreferences() ?? '';

    return Selector<GameX01_P, bool>(
      selector: (context, gameX01) => gameX01.getShowLoadingSpinner,
      builder: (context, showLoadingSpinner, _) => AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 15.sp),
        ),
        leading: widget.isFinishScreen
            ? SizedBox.shrink()
            : IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  Utils.handleVibrationFeedback(context);
                  var route = ModalRoute.of(context);
                  if (route != null) {
                    Navigator.of(context).pop();
                  }
                },
                icon: Icon(
                  size: ICON_BUTTON_SIZE.h,
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
        actions: [
          if (widget.showHeart && username != 'Guest')
            IconButton(
              iconSize: ICON_BUTTON_SIZE.h,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () async {
                Utils.handleVibrationFeedback(context);
                if (!showLoadingSpinner) {
                  _addGameToFavourites();
                }
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
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                Utils.handleVibrationFeedback(context);
                if (!showLoadingSpinner) {
                  _resetGame(context);
                  Navigator.of(context).pushNamed('/home');
                }
              },
              icon: Icon(
                size: ICON_BUTTON_SIZE.h,
                Icons.home,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
        ],
      ),
    );
  }

  _changeFavouriteStateOfGame(String gameId, bool state) async {
    setState(() {
      widget.isFavouriteGame = state;
    });

    if (widget.gameId != null) {
      final dynamic statsFirestore =
          Utils.getFirestoreStatsProviderBasedOnMode(widget.mode, context);
      statsFirestore.games
          .firstWhere((game) => game.getGameId == gameId)
          .setIsFavouriteGame = state;
    }

    await context
        .read<FirestoreServiceGames>()
        .changeFavouriteStateOfGame(gameId, state);
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
    if (widget.mode == GameMode.X01) {
      context.read<GameX01_P>().reset();
    } else if (widget.mode == GameMode.ScoreTraining) {
      context.read<GameScoreTraining_P>().reset();
    } else if (widget.mode == GameMode.SingleTraining ||
        widget.mode == GameMode.DoubleTraining) {
      context.read<GameSingleDoubleTraining_P>().reset();
    } else if (widget.mode == GameMode.Cricket) {
      context.read<GameCricket_P>().reset();
    }
  }
}
