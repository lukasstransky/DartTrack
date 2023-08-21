import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_single_double_training_p.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class GameInfoSingleDoubleTraining extends StatelessWidget {
  const GameInfoSingleDoubleTraining({Key? key, required this.gameMode})
      : super(key: key);

  final GameMode gameMode;

  _getInfoBasedOnMode(ModesSingleDoubleTraining mode, BuildContext context,
      bool isSingleTraining) {
    switch (mode) {
      case ModesSingleDoubleTraining.Ascending:
        return RichText(
          text: TextSpan(
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize),
            text: 'Starting from',
            children: <TextSpan>[
              TextSpan(
                text: isSingleTraining ? ' 1' : ' D1',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(text: ' to'),
              TextSpan(
                text: isSingleTraining ? ' 20' : ' D20',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(text: '.'),
            ],
          ),
        );

      case ModesSingleDoubleTraining.Descending:
        return RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
            ),
            text: 'Starting from',
            children: <TextSpan>[
              TextSpan(
                text: isSingleTraining ? ' 20' : ' D20',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(text: ' to'),
              TextSpan(
                text: isSingleTraining ? ' 1' : ' D1',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(text: '.'),
            ],
          ),
        );
      case ModesSingleDoubleTraining.Random:
        return RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Random',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ' fields will be displayed.',
              ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isSingleTraining = gameMode == GameMode.SingleTraining;

    return Container(
      padding: EdgeInsets.only(top: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Selector<GameSettingsSingleDoubleTraining_P,
              ModesSingleDoubleTraining>(
            selector: (_, settings) => settings.getMode,
            builder: (_, mode, __) =>
                _getInfoBasedOnMode(mode, context, isSingleTraining),
          ),
          Text(
            'For each round you have 3 darts to throw.',
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
