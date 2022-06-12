import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:flutter/material.dart';

class GameModesOverView extends StatefulWidget {
  const GameModesOverView({Key? key}) : super(key: key);

  @override
  _GameModesOverViewScreenState createState() =>
      _GameModesOverViewScreenState();
}

class _GameModesOverViewScreenState extends State<GameModesOverView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(false, "Game Modes"),
      body: Center(
        child: ElevatedButton(
          child: Text("X01"),
          key: Key("x01GameBtn"),
          onPressed: () => Navigator.of(context).pushNamed("/settingsX01"),
        ),
      ),
    );
  }
}
