import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/x01/game_x01.dart';
import 'package:dart_app/models/player_statistics/x01/player_or_team_game_statistics_x01.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sizer/sizer.dart';

class StatsCardFiltered extends StatefulWidget {
  const StatsCardFiltered(
      {Key? key, required this.game, required this.orderField})
      : super(key: key);

  final GameX01? game;
  final String orderField;

  @override
  State<StatsCardFiltered> createState() => _StatsCardFilteredState();
}

class _StatsCardFilteredState extends State<StatsCardFiltered> {
  String _getValueOfOrderField() {
    //todo change
    const String currentPlayerName =
        //await context.read<AuthService>().getPlayer!.getName;
        'Strainski';

    for (PlayerOrTeamGameStatisticsX01 playerStats
        in widget.game!.getPlayerGameStatistics) {
      if (playerStats.getPlayer.getName == currentPlayerName) {
        switch (widget.orderField) {
          case 'average':
            return playerStats.getAverage();
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
    //todo change
    const String currentPlayerName =
        //await context.read<AuthService>().getPlayer!.getName;
        'Strainski';

    for (PlayerOrTeamGameStatisticsX01 playerStats
        in widget.game!.getPlayerGameStatistics) {
      if (playerStats.getPlayer.getName == currentPlayerName) {
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
        result += 'First Nine Avg.: ';
        break;
      case 'checkoutInPercent':
        result += 'Checkout in Percent: ';
        break;
      case 'highestFinish':
        result += 'Highest Finish: ';
        break;
      case 'bestLeg':
        result += 'Darts for Leg: ';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
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
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.game!.getFormattedDateTime(),
                      style: TextStyle(fontSize: 10.sp),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, bottom: 5),
              child: Text(
                widget.game!.getGameSettings.getGameModeDetails(true),
                style: TextStyle(fontSize: 12.sp),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, bottom: 10),
              child: Text(
                widget.game!.getGameSettings.getSingleOrTeam ==
                        SingleOrTeamEnum.Single
                    ? 'Single Mode'
                    : 'Team Mode',
                style: TextStyle(fontSize: 12.sp),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, bottom: 10),
              child: Text(
                _getField(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
              ),
            )
          ],
        ),
      ),
    );
  }
}
