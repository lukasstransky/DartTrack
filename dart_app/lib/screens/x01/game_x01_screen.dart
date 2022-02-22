import 'package:dart_app/other/custom_app_bar.dart';
import 'package:dart_app/models/game_settings/game_settings_x01_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class GameX01Screen extends StatefulWidget {
  static const routeName = "/gameX01";

  const GameX01Screen({Key? key}) : super(key: key);

  @override
  _GameX01ScreenState createState() => _GameX01ScreenState();
}

class _GameX01ScreenState extends State<GameX01Screen> {
  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(true, "Game Settings"),
    );
  }
}
