import 'package:dart_app/models/firestore/stats_firestore_x01_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtherStats extends StatelessWidget {
  const OtherStats({Key? key}) : super(key: key);

  String _getGamesWonString(StatsFirestoreX01_P statisticsFirestore) {
    if (statisticsFirestore.countOfGames == 0) {
      return '-';
    }
    if (statisticsFirestore.countOfGames > 0 &&
        statisticsFirestore.countOfGamesWon == 0) {
      return '0 (0%)';
    }

    String winPercentage =
        ((100 * (statisticsFirestore.countOfGamesWon as int)) /
                statisticsFirestore.countOfGames)
            .toStringAsFixed(2);

    // remove .00 after comma if present
    final List<String> parts = winPercentage.toString().split('.');
    if (parts[1] == '00') {
      winPercentage = parts[0];
    }

    return '${statisticsFirestore.countOfGamesWon} (${winPercentage}%)';
  }

  @override
  Widget build(BuildContext context) {
    Color color = Utils.getTextColorDarken(context);
    return Consumer<StatsFirestoreX01_P>(
      builder: (_, statisticsFirestore, __) => Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        statisticsFirestore.countOf180 > 0
                            ? statisticsFirestore.countOf180.toString()
                            : '-',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '180',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        statisticsFirestore.countOfAllDarts > 0
                            ? statisticsFirestore.countOfAllDarts.toString()
                            : '-',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Darts',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        statisticsFirestore.countOfGames > 0
                            ? statisticsFirestore.countOfGames.toString()
                            : '-',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Games',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        _getGamesWonString(statisticsFirestore),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Games won',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
