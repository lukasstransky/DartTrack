import 'package:dart_app/constants.dart';
import 'package:dart_app/screens/game_modes/shared/select_input_method/local_widgets/round_mode_btn.dart';
import 'package:dart_app/screens/game_modes/shared/select_input_method/local_widgets/three_darts_mode_btn.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SelectInputMethod extends StatelessWidget {
  const SelectInputMethod({Key? key, required this.mode}) : super(key: key);

  final GameMode mode;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RoundBtn(mode: mode),
          ThreeDartsBtn(mode: mode),
        ],
      ),
    );
  }
}
