import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ShowTeamsOrPlayersStatsBtn extends StatelessWidget {
  const ShowTeamsOrPlayersStatsBtn({Key? key, required this.gameX01})
      : super(key: key);

  final GameX01 gameX01;

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = gameX01.getGameSettings;

    if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team)
      return Container(
        width: WIDTH_HEADINGS_STATISTICS.w,
        padding: EdgeInsets.only(left: 5.w, right: 5.w),
        transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
        child: ElevatedButton(
          onPressed: () {
            context.read<GameX01>().setAreTeamStatsDisplayed =
                !gameX01.getAreTeamStatsDisplayed;
            context.read<GameX01>().notify();

            // only for stats tab
            if (gameX01.getIsGameFinished || gameX01.getIsOpenGame) {
              gameX01.setAreTeamStatsDisplayed =
                  !gameX01.getAreTeamStatsDisplayed;
              gameX01.notify();
            }
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              gameX01.getAreTeamStatsDisplayed ? 'Show Players' : 'Show Teams',
              style: TextStyle(
                fontSize: 10.sp,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
            backgroundColor: Utils.getPrimaryMaterialStateColorDarken(context),
            overlayColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.primary),
          ),
        ),
      );
    return Container(
      width: WIDTH_HEADINGS_STATISTICS.w,
    );
  }
}
