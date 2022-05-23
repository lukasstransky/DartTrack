import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class StatsCardFiltered extends StatefulWidget {
  const StatsCardFiltered(
      {Key? key, required this.game, required this.orderField})
      : super(key: key);

  final Game? game;
  final String orderField;

  @override
  State<StatsCardFiltered> createState() => _StatsCardFilteredState();
}

class _StatsCardFilteredState extends State<StatsCardFiltered> {
  String _getValueOfOrderField() {
    final String currentPlayerName =
        //await context.read<AuthService>().getPlayer!.getName;
        "Strainski";

    for (PlayerGameStatisticsX01 playerStats
        in widget.game!.getPlayerGameStatistics) {
      if (playerStats.getPlayer.getName == currentPlayerName) {
        switch (widget.orderField) {
          case "average":
            return playerStats.getAverage(widget.game as Game, playerStats);
          case "firstNineAverage":
            return playerStats.getFirstNineAverage.toString();
          case "checkoutInPercent":
            return playerStats.getCheckoutQuoteInPercent();
          case "highestFinish":
            return playerStats.getHighestCheckout().toString();
          case "bestLeg":
            return playerStats.getBestLeg();
        }
      }
    }

    return "";
  }

  String _getField() {
    String result = "";
    switch (widget.orderField) {
      case "average":
        result += "Average: ";
        break;
      case "firstNineAverage":
        result += "First Nine Average: ";
        break;
      case "checkoutInPercent":
        result += "Checkout in Percent: ";
        break;
      case "highestFinish":
        result += "Highest Finish: ";
        break;
      case "bestLeg":
        result += "Darts for Leg: ";
        break;
    }
    result += _getValueOfOrderField();

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/statisticsX01",
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
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.game!.getGameSettings.getGameMode(),
                      style: TextStyle(fontSize: 12.sp),
                    ),
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
              padding: EdgeInsets.only(left: 10, bottom: 10),
              child: Text(widget.game!.getGameSettings.getGameModeDetails(true),
                  style: TextStyle(fontSize: 12.sp)),
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
