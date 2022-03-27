import 'package:dart_app/screens/game_modes/x01/finish/local_widgets/buttons.dart';
import 'package:dart_app/screens/game_modes/x01/finish/local_widgets/stats_card.dart';
import 'package:dart_app/utils/custom_app_bar_x01_finished.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:developer';

class Finish extends StatelessWidget {
  static const routeName = "/finishX01";

  const Finish({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarX01Finished("Finished Game"),
      body: Center(
        child: Container(
          width: 90.w,
          child: Column(
            children: [
              StatsCard(),
              Buttons(),
            ],
          ),
        ),
      ),
    );
  }
}
