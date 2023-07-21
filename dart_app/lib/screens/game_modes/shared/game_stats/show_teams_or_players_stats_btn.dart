import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ShowTeamsOrPlayersStatsBtn extends StatelessWidget {
  const ShowTeamsOrPlayersStatsBtn({Key? key, required this.game})
      : super(key: key);

  final dynamic game;

  @override
  Widget build(BuildContext context) {
    final dynamic gameSettings = game.getGameSettings;
    final bool isGameX01 = game is GameX01_P;
    final double width = WIDTH_HEADINGS_STATISTICS.w +
        (isGameX01 ? 0.w : PADDING_LEFT_STATISTICS.w);

    if (gameSettings.getSingleOrTeam == SingleOrTeamEnum.Team)
      return Container(
        width: width,
        padding: EdgeInsets.only(
          left: isGameX01 ? 0 : 5.w,
          right: 5.w,
          top: PADDING_TOP_STATISTICS.w,
        ),
        child: ElevatedButton(
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            late dynamic providerGame;
            if (game is GameX01_P) {
              providerGame = context.read<GameX01_P>();
            } else if (game is GameCricket_P) {
              providerGame = context.read<GameCricket_P>();
            }

            // only for stats tab
            if (game.getIsOpenGame || game.getIsGameFinished) {
              game.setAreTeamStatsDisplayed = !game.getAreTeamStatsDisplayed;
              game.notify();

              if (providerGame.hashCode != game.hashCode) {
                providerGame.setAreTeamStatsDisplayed =
                    !providerGame.getAreTeamStatsDisplayed;
                providerGame.notify();
              }
            } else {
              providerGame.setAreTeamStatsDisplayed =
                  !providerGame.getAreTeamStatsDisplayed;
              providerGame.notify();
            }
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              game.getAreTeamStatsDisplayed ? 'Show players' : 'Show teams',
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
    return Container(width: width);
  }
}
