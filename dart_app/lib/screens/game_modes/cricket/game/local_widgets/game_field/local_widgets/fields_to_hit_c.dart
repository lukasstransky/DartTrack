import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class FieldsToHit extends StatelessWidget {
  const FieldsToHit({
    Key? key,
    this.oddPlayersOrTeams = false,
  }) : super(key: key);

  final bool oddPlayersOrTeams;

  @override
  Widget build(BuildContext context) {
    final GameCricket_P gameCricket = context.read<GameCricket_P>();
    final GameSettingsCricket_P gameSettingsCricket =
        context.read<GameSettingsCricket_P>();

    final BorderSide _borderSide = BorderSide(
      width: GENERAL_BORDER_WIDTH.w,
      color: Utils.getPrimaryColorDarken(context),
    );

    final Color _darkenPrimaryColor20 =
        Utils.darken(Theme.of(context).colorScheme.primary, 20);
    final bool _is25Closed =
        gameCricket.isNumberClosed(25, gameSettingsCricket);

    return Container(
      width: 20.w,
      child: Column(
        children: [
          for (int i = 20; i >= 15; i--)
            Expanded(
              child: (() {
                final bool isNumberClosed =
                    gameCricket.isNumberClosed(i, gameSettingsCricket);

                return Container(
                  decoration: BoxDecoration(
                    color: isNumberClosed
                        ? Theme.of(context).colorScheme.primary
                        : _darkenPrimaryColor20,
                    border: Border(
                      top: _borderSide,
                      left: oddPlayersOrTeams &&
                              gameCricket.getSafeAreaPadding.left > 0 &&
                              Utils.isLandscape(context)
                          ? _borderSide
                          : BorderSide.none,
                    ),
                  ),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        i.toString(),
                        style: TextStyle(
                          color: isNumberClosed ? Colors.white54 : Colors.white,
                          fontSize:
                              Theme.of(context).textTheme.titleSmall!.fontSize,
                          fontWeight: FontWeight.bold,
                          decoration: isNumberClosed
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                );
              })(),
            ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: _is25Closed
                    ? Theme.of(context).colorScheme.primary
                    : _darkenPrimaryColor20,
                border: Border(
                  top: _borderSide,
                  bottom: _borderSide,
                  left: oddPlayersOrTeams &&
                          gameCricket.getSafeAreaPadding.left > 0 &&
                          Utils.isLandscape(context)
                      ? _borderSide
                      : BorderSide.none,
                ),
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Bull',
                    style: TextStyle(
                      color: _is25Closed ? Colors.white54 : Colors.white,
                      fontSize:
                          Theme.of(context).textTheme.titleSmall!.fontSize,
                      fontWeight: FontWeight.bold,
                      decoration: _is25Closed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
