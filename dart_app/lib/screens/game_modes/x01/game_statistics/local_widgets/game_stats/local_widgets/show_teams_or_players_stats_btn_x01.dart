import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ShowTeamsOrPlayersStatsBtnX01 extends StatelessWidget {
  const ShowTeamsOrPlayersStatsBtnX01({Key? key, required this.gameX01})
      : super(key: key);

  final GameX01_P gameX01;

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = gameX01.getGameSettings;

    if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team)
      return Container(
        width: WIDTH_HEADINGS_STATISTICS.w - 10.w,
        child: ElevatedButton(
          onPressed: () {
            final gameX01_p = context.read<GameX01_P>();

            // only for stats tab
            if (gameX01.getIsOpenGame || gameX01.getIsGameFinished) {
              gameX01.setAreTeamStatsDisplayed =
                  !gameX01.getAreTeamStatsDisplayed;
              gameX01.notify();

              if (gameX01_p.hashCode != gameX01.hashCode) {
                gameX01_p.setAreTeamStatsDisplayed =
                    !gameX01_p.getAreTeamStatsDisplayed;
                gameX01_p.notify();
              }
            } else {
              gameX01_p.setAreTeamStatsDisplayed =
                  !gameX01_p.getAreTeamStatsDisplayed;
              gameX01_p.notify();
            }
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              gameX01.getAreTeamStatsDisplayed ? 'Show players' : 'Show teams',
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
            splashFactory: NoSplash.splashFactory,
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ),
        ),
      );
    return Container(
      width: WIDTH_HEADINGS_STATISTICS.w - 10.w,
    );
  }
}
