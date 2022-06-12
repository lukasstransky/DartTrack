import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/statistics_firestore_x01.dart';
import 'package:dart_app/screens/game_modes/x01/finish/local_widgets/stats_card/stats_card_x01.dart';
import 'package:dart_app/services/firestore_service.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class StatsPerGameList extends StatefulWidget {
  StatsPerGameList({Key? key}) : super(key: key);

  static const routeName = "/statsPerGameList";

  @override
  State<StatsPerGameList> createState() => _StatsPerGameListState();
}

class _StatsPerGameListState extends State<StatsPerGameList> {
  String _mode = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getGames();
  }

  _getGames() async {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
            <String, dynamic>{})
        as Map; //extract arguments that are passed into in order to get game mode (X01, Cricket...)
    _mode = arguments.entries.first.value.toString();
    context.read<FirestoreService>().getGames(_mode, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(true, _mode + " Games"),
      body: Consumer<StatisticsFirestoreX01>(
        builder: (_, statisticsFirestore, __) =>
            statisticsFirestore.games.length > 0
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
                                      "(Click Card to view Details about a Game)")),
                            ),
                            if (statisticsFirestore.games.isNotEmpty)
                              statisticsFirestore.sortGames() == null
                                  ? SizedBox.shrink()
                                  : SizedBox.shrink(),
                            for (Game game in statisticsFirestore.games) ...[
                              if (_mode == "X01")
                                StatsCardX01(isFinishScreen: false, game: game),
                              //add cards for other modes (StatsCardCricket)
                            ]
                          ],
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: statisticsFirestore.noGamesPlayed
                        ? Text("No " + _mode + " Games have been played yet!")
                        : CircularProgressIndicator(),
                  ),
      ),
    );
  }
}
