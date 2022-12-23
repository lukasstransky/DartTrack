import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GameDetails extends StatelessWidget {
  const GameDetails({Key? key, required this.gameX01}) : super(key: key);

  final GameX01 gameX01;

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01 gameSettingsX01 = gameX01.getGameSettings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.only(top: 1.h, left: 2.w, right: 2.w, bottom: 0.5.h),
          child: Row(
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  gameX01.isGameDraw()
                      ? 'Draw - ${gameSettingsX01.getGameMode()}'
                      : '${gameSettingsX01.getGameMode()}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                    color: Utils.getTextColorDarken(context),
                  ),
                ),
              ),
              Spacer(),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  gameX01.getFormattedDateTime(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 2.w, bottom: 0.5.h),
          child: Text(
            'X01 (${gameSettingsX01.getGameModeDetails(true)}',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 2.w, bottom: 0.5.h),
          child: Text(
            gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single
                ? 'Single Mode'
                : 'Team Mode',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
