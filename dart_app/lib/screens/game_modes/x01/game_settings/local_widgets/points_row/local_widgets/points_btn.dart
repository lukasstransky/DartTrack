import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:sizer/sizer.dart';

class PointsBtn extends StatelessWidget {
  const PointsBtn({
    Key? key,
    required this.points,
  }) : super(key: key);

  final int points;

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    return Expanded(
      child: Selector<GameSettingsX01, Tuple2<int, int>>(
        selector: (_, gameSettingsX01) =>
            Tuple2(gameSettingsX01.getPoints, gameSettingsX01.getCustomPoints),
        builder: (_, tuple, __) => Container(
          height: WIDGET_HEIGHT_GAMESETTINGS.h,
          child: ElevatedButton(
            onPressed: () => {
              gameSettingsX01.setPoints = points,
              gameSettingsX01.notify(),
            },
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                points.toString(),
              ),
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: points != 301
                      ? BorderRadius.zero
                      : BorderRadius.only(
                          topLeft: Radius.circular(BUTTON_BORDER_RADIUS),
                          bottomLeft: Radius.circular(BUTTON_BORDER_RADIUS),
                        ),
                ),
              ),
              backgroundColor: tuple.item1 == points && tuple.item2 == -1
                  ? Utils.getColor(Theme.of(context).colorScheme.primary)
                  : Utils.getColor(Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
