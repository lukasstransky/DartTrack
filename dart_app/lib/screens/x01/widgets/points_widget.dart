import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:sizer/sizer.dart';

class PointsWidget extends StatelessWidget {
  const PointsWidget({
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
        builder: (_, tuple, __) => SizedBox(
          height: HEIGHT_GAMESETTINGS_WIDGETS.h,
          child: ElevatedButton(
            onPressed: () => gameSettingsX01.setPoints = points,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(points.toString()),
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: points != 301
                      ? BorderRadius.zero
                      : BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10),
                        ),
                ),
              ),
              backgroundColor: tuple.item1 == points && tuple.item2 == -1
                  ? MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary)
                  : MaterialStateProperty.all<Color>(Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
