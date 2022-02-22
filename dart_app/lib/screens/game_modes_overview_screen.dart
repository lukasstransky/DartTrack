import 'package:flutter/material.dart';

class GameModesOverViewScreen extends StatefulWidget {
  const GameModesOverViewScreen({Key? key}) : super(key: key);

  @override
  _GameModesOverViewScreenState createState() =>
      _GameModesOverViewScreenState();
}

class _GameModesOverViewScreenState extends State<GameModesOverViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("X01"),
          onPressed: () => Navigator.of(context).pushNamed("/settingsX01"),
        ),
      ),
    );
  }
}
