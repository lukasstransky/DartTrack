import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sizer/sizer.dart';

class PlayerEntry extends StatelessWidget {
  const PlayerEntry(
      {Key? key,
      required this.i,
      required this.gameX01,
      required this.openGame})
      : super(key: key);

  final int i;
  final GameX01 gameX01;
  final bool openGame;

  bool _isGameDraw() {
    for (PlayerGameStatisticsX01 stats in gameX01.getPlayerGameStatistics) {
      if (stats.getGameDraw) {
        return true;
      }
    }
    return false;
  }

  bool _firstElementNoDrawOrOpenGame() {
    return i == 0 && !_isGameDraw() && !openGame;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 10,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                bottom:
                    i != gameX01.getPlayerGameStatistics.length - 1 ? 0 : 10),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  child: Row(
                    children: [
                      _isGameDraw()
                          ? SizedBox.shrink()
                          : Text(
                              '${(i + 1)}.',
                              style: TextStyle(
                                  fontSize: _firstElementNoDrawOrOpenGame()
                                      ? DEFAULT_FONTSIZE_BIG.sp
                                      : DEFAULT_FONTSIZE.sp,
                                  fontWeight: (i == 0 && !openGame)
                                      ? FontWeight.bold
                                      : null),
                            ),
                      if (_firstElementNoDrawOrOpenGame())
                        Container(
                          padding: const EdgeInsets.only(right: 5, left: 10),
                          transform: Matrix4.translationValues(0.0, -2.0, 0.0),
                          child: Icon(
                            Entypo.trophy,
                            size: DEFAULT_FONTSIZE.sp,
                            color: Color(0xffFFD700),
                          ),
                        ),
                      if (gameX01.getPlayerGameStatistics[i].getPlayer
                          is Bot) ...[
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            children: [
                              Text(
                                'Lvl. ${gameX01.getPlayerGameStatistics[i].getPlayer.getLevel} Bot',
                                style: TextStyle(
                                  fontSize: _firstElementNoDrawOrOpenGame()
                                      ? DEFAULT_FONTSIZE_BIG.sp
                                      : DEFAULT_FONTSIZE.sp,
                                ),
                              ),
                              Text(
                                ' (${gameX01.getPlayerGameStatistics[i].getPlayer.getPreDefinedAverage.round() - BOT_AVG_SLIDER_VALUE_RANGE}-${gameX01.getPlayerGameStatistics[i].getPlayer.getPreDefinedAverage.round() + BOT_AVG_SLIDER_VALUE_RANGE} avg.)',
                                style: TextStyle(
                                  fontSize: 8.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        Padding(
                          padding: EdgeInsets.only(
                              left: _isGameDraw() || openGame ? 10 : 0),
                          child: Text(
                            gameX01
                                .getPlayerGameStatistics[i].getPlayer.getName,
                            style: TextStyle(
                                fontSize: _firstElementNoDrawOrOpenGame()
                                    ? DEFAULT_FONTSIZE_BIG.sp
                                    : DEFAULT_FONTSIZE.sp,
                                fontWeight: _firstElementNoDrawOrOpenGame()
                                    ? FontWeight.bold
                                    : null),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Container(
                    width: 40.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            gameX01.getGameSettings.getSetsEnabled
                                ? 'Sets: ${gameX01.getPlayerGameStatistics[i].getSetsWon}'
                                : 'Legs: ${gameX01.getPlayerGameStatistics[i].getLegsWon}',
                            style: TextStyle(fontSize: DEFAULT_FONTSIZE.sp)),
                        Text(
                            'Average: ${gameX01.getPlayerGameStatistics[i].getAverage()}',
                            style: TextStyle(fontSize: DEFAULT_FONTSIZE.sp)),
                        if (gameX01.getGameSettings.getEnableCheckoutCounting)
                          Text(
                            'Checkout: ${gameX01.getPlayerGameStatistics[i].getCheckoutQuoteInPercent()}',
                            style: TextStyle(fontSize: DEFAULT_FONTSIZE.sp),
                          ),
                      ],
                    ),
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
