import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/open_games_firestore.dart';
import 'package:dart_app/screens/game_modes/x01/finish/local_widgets/stats_card/stats_card_x01.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class OpenGames extends StatefulWidget {
  static const routeName = '/openGames';

  const OpenGames({Key? key}) : super(key: key);

  @override
  State<OpenGames> createState() => _OpenGamesState();
}

class _OpenGamesState extends State<OpenGames> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(true, 'Open Games'),
      body: Consumer<OpenGamesFirestore>(
        builder: (_, openGamesFirestore, __) => openGamesFirestore
                    .openGames.length !=
                0
            ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Center(
                  child: Container(
                    width: 90.w,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: 10,
                            left: 5,
                          ),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  'Swipe left for Actions (Play & Delete)')),
                        ),
                        for (Game game in openGamesFirestore.openGames) ...[
                          Slidable(
                            key: ValueKey(game.getGameId),
                            child: StatsCardX01(
                                isFinishScreen: false,
                                gameX01: GameX01.createGameX01(game),
                                openGame: true),
                            startActionPane: ActionPane(
                              dismissible: DismissiblePane(onDismissed: () {}),
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    Provider.of<GameX01>(context, listen: false)
                                        .setNewGameValuesFromOpenGame(
                                            game, context);
                                    Navigator.of(context).pushNamed(
                                      '/gameX01',
                                      arguments: {'openGame': true},
                                    );
                                  },
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  icon: Icons.arrow_forward,
                                  label: 'Play',
                                ),
                                SlidableAction(
                                  onPressed: (context) {
                                    context
                                        .read<FirestoreServiceGames>()
                                        .deleteOpenGame(
                                            game.getGameId, context);
                                  },
                                  backgroundColor: Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: Text('Currently there are no Open Games!'),
              ),
      ),
    );
  }
}
