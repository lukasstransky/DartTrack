import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:flutter/material.dart';

class GameSettingsScoreTraining extends StatelessWidget {
  static const routeName = '/settingsScoreTraining';

  const GameSettingsScoreTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: 'Score Training Settings'),
      body: SafeArea(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
