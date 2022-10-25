import 'package:dart_app/models/firestore/statistics_firestore_x01.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtherStats extends StatelessWidget {
  const OtherStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<StatisticsFirestoreX01>(
        builder: (_, statisticsFirestore, __) => Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(statisticsFirestore.countOf180 > 0
                                ? statisticsFirestore.countOf180.toString()
                                : '-'),
                            const Text(
                              '180',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(statisticsFirestore.countOfAllDarts > 0
                                ? statisticsFirestore.countOfAllDarts.toString()
                                : '-'),
                            const Text(
                              'Darts',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(statisticsFirestore.countOfGames > 0
                                ? statisticsFirestore.countOfGames.toString()
                                : '-'),
                            const Text(
                              'Games',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(statisticsFirestore.countOfGamesWon > 0
                                ? statisticsFirestore.countOfGamesWon.toString()
                                : '-'),
                            const Text(
                              'Games Won',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }
}
