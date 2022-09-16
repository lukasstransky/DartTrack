import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PointsBtn extends StatelessWidget {
  const PointsBtn({
    Key? key,
    required this.points,
  }) : super(key: key);

  final int points;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<GameSettingsX01>(
        builder: (_, gameSettingsX01, __) => Container(
          height: Utils.getHeightForWidget(gameSettingsX01).h,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(width: 1.0, color: Colors.white),
            ),
            color: Colors.white,
          ),
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
              splashFactory: gameSettingsX01.getPoints == points &&
                      gameSettingsX01.getCustomPoints == -1
                  ? NoSplash.splashFactory
                  : InkRipple.splashFactory,
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: gameSettingsX01.getPoints == points &&
                      gameSettingsX01.getCustomPoints == -1
                  ? MaterialStateProperty.all(Colors.transparent)
                  : Utils.getDefaultOverlayColor(context),
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
              backgroundColor: gameSettingsX01.getPoints == points &&
                      gameSettingsX01.getCustomPoints == -1
                  ? Utils.getColor(Theme.of(context).colorScheme.primary)
                  : Utils.getColor(Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
