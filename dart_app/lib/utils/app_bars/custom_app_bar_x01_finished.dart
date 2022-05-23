import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

class CustomAppBarX01Finished extends StatelessWidget with PreferredSizeWidget {
  CustomAppBarX01Finished(this.title);

  final String title;

  saveDataToFirestore(BuildContext context) async {
    String gameId = "";
    gameId = await context
        .read<FirestoreService>()
        .postGame(Provider.of<GameX01>(context, listen: false));
    await context.read<FirestoreService>().postPlayerGameStatistics(
        Provider.of<GameX01>(context, listen: false), gameId, context);
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
                  Navigator.of(context).pushNamed("/home"),
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
