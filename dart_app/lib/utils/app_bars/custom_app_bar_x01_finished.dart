import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/services/firestore/firestore_service_player_stats.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class CustomAppBarX01Finished extends StatelessWidget with PreferredSizeWidget {
  CustomAppBarX01Finished(this.title);

  final String title;

  saveDataToFirestore(BuildContext context) async {
    final GameSettingsX01 gameSettingsX01 = context.read<GameSettingsX01>();
    final GameX01 gameX01 = context.read<GameX01>();
    //todo comment out
    //if (gameSettingsX01.isCurrentUserInPlayers(context)) {
    String gameId = '';
    gameId = await context.read<FirestoreServiceGames>().postGame(gameX01);
    await context
        .read<FirestoreServicePlayerStats>()
        .postPlayerGameStatistics(gameX01, gameId, context);
    //}

    if (gameX01.getIsOpenGame) {
      await context
          .read<FirestoreServiceGames>()
          .deleteOpenGame(gameX01.getGameId, context);
    }
  }

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
            onPressed: () => {
                  Navigator.of(context).pushNamed('/home'),
                  saveDataToFirestore(context),
                },
            icon: Icon(
              Icons.home,
            )),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
