import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class StatsCardFiltered extends StatefulWidget {
  const StatsCardFiltered(
      {Key? key, required this.game, required this.orderField})
      : super(key: key);

  final GameX01_P? game;
  final String orderField;

  @override
  State<StatsCardFiltered> createState() => _StatsCardFilteredState();
}

class _StatsCardFilteredState extends State<StatsCardFiltered> {
  String _getValueOfOrderField() {
    final String username =
        context.read<AuthService>().getUsernameFromSharedPreferences() ?? '';

    for (PlayerOrTeamGameStatsX01 playerStats
        in widget.game!.getPlayerGameStatistics) {
      if (playerStats.getPlayer.getName == username) {
        switch (widget.orderField) {
          case 'average':
            return playerStats.getAverage(context.read<GameSettingsX01_P>());
          case 'firstNineAvg':
            return playerStats.getFirstNinveAvg();
          case 'checkoutInPercent':
            return playerStats.getCheckoutQuoteInPercent();
          case 'highestFinish':
            return playerStats.getHighestCheckout().toString();
          case 'bestLeg':
            return playerStats.getBestLeg();
        }
      }
    }

    return '';
  }

  bool _isGameWonByCurrentPlayer() {
    final String username =
        context.read<AuthService>().getUsernameFromSharedPreferences() ?? '';

    for (PlayerOrTeamGameStatsX01 playerStats
        in widget.game!.getPlayerGameStatistics) {
      if (playerStats.getPlayer.getName == username) {
        if (playerStats.getGameWon) {
          return true;
        }
      }
    }

    return false;
  }

  String _getField() {
    String result = '';
    switch (widget.orderField) {
      case 'average':
        result += 'Average: ';
        break;
      case 'firstNineAvg':
        result += 'First nine avg.: ';
        break;
      case 'checkoutInPercent':
        result += 'Checkout in percent: ';
        break;
      case 'highestFinish':
        result += 'Highest finish: ';
        break;
      case 'bestLeg':
        result += 'Darts for leg: ';
        break;
    }
    result += _getValueOfOrderField();

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/statisticsX01',
            arguments: {'game': widget.game});
      },
      child: Card(
        color: Utils.darken(Theme.of(context).colorScheme.primary, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 5,
                left: 10,
                right: 10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      if (_isGameWonByCurrentPlayer())
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(
                            Entypo.trophy,
                            size: 12.sp,
                            color: Color(0xffFFD700),
                          ),
                        ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.game!.getGameSettings.getGameMode(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.game!.getFormattedDateTime(),
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
              padding: EdgeInsets.only(
                left: 10,
              ),
              child: Text(
                widget.game!.getGameSettings.getGameModeDetails(true),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 10,
                bottom: 5,
              ),
              child: Text(
                widget.game!.getGameSettings.getSingleOrTeam ==
                        SingleOrTeamEnum.Single
                    ? 'Single mode'
                    : 'Team mode',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 10,
                bottom: 5,
              ),
              child: Text(
                _getField(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color: Utils.getTextColorDarken(context),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
