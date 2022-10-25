import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/screens/game_modes/x01/finish/local_widgets/buttons.dart';
import 'package:dart_app/screens/game_modes/x01/finish/local_widgets/stats_card/stats_card_x01.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar_x01_finished.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Finish extends StatelessWidget {
  static const routeName = '/finishX01';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarX01Finished('Finished Game'),
      body: Center(
        child: Container(
          width: 90.w,
          child: Column(
            children: [
              StatsCardX01(
                isFinishScreen: true,
                gameX01: context.read<GameX01>(),
                openGame: false,
              ),
              Buttons(),
            ],
          ),
        ),
      ),
    );
  }
}
