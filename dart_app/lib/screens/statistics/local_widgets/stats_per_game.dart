import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/services/firestore_service.dart';
import 'package:dart_app/utils/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatsPerGame extends StatefulWidget {
  StatsPerGame({Key? key}) : super(key: key);

  static const routeName = "/statsPerGame";

  @override
  State<StatsPerGame> createState() => _StatsPerGameState();
}

class _StatsPerGameState extends State<StatsPerGame> {
  String _mode = "";
  List<Game> _games = [];

  @override
  void initState() {
    super.initState();

    //getGames();
  }

  getGames() async {
    _games = await context.read<FirestoreService>().getGames(_mode);
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
            <String, dynamic>{})
        as Map; //extract arguments that are passed into in order to get game mode (X01, Cricket...)
    _mode = arguments.entries.first.value.toString();
    getGames();

    return Scaffold(
      appBar: CustomAppBar(true, "Stats per Game"),
      body: Container(
        child: Text(
          _mode,
        ),
      ),
    );
  }
}
