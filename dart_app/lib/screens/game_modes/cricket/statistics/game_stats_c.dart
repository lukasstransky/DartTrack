import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/screens/game_modes/cricket/statistics/local_widgets/main_stats_c.dart';
import 'package:dart_app/screens/game_modes/cricket/statistics/local_widgets/points_per_number_c.dart';
import 'package:dart_app/screens/game_modes/shared/game_stats/player_or_team_names.dart';
import 'package:dart_app/screens/game_modes/shared/game_stats/show_teams_or_players_stats_btn.dart';

import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar_with_heart.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class StatisticsCricket extends StatefulWidget {
  static const routeName = '/statisticsCricket';

  const StatisticsCricket({Key? key}) : super(key: key);

  @override
  State<StatisticsCricket> createState() => _StatisticsCricketState();
}

class _StatisticsCricketState extends State<StatisticsCricket> {
  GameCricket_P? _game;
  bool _showSimpleAppBar = false;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    if (arguments.isNotEmpty) {
      if (arguments.containsKey('game')) {
        _game = arguments['game'];
      }
      if (arguments.containsKey('showSimpleAppBar'))
        _showSimpleAppBar = arguments['showSimpleAppBar'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _game!.getIsGameFinished && !_showSimpleAppBar
          ? CustomAppBarWithHeart(
              title: 'Statistics',
              mode: GameMode.Cricket,
              isFavouriteGame: _game!.getIsFavouriteGame,
              gameId: _game!.getGameId,
            )
          : CustomAppBar(title: 'Statistics'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 1.h),
              child: Text(
                _getHeader(context.read<GameSettingsCricket_P>()),
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                top: 0.5.h,
                bottom: 1.h,
              ),
              child: Text(
                _game!.getFormattedDateTime(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Utils.getTextColorDarken(context),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Selector<GameCricket_P, bool>(
                  selector: (_, game) => game.getAreTeamStatsDisplayed,
                  builder: (_, areTeamStatsDisplayed, __) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ShowTeamsOrPlayersStatsBtn(game: _game!),
                          PlayerOrTeamNames(game: _game!),
                        ],
                      ),
                      MainStatsCricket(game: _game!),
                      PointsPerNumberCricket(game: _game!),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getHeader(GameSettingsCricket_P gameSettingsCricket) {
    return 'Cricket - ${gameSettingsCricket.getMode.name}';
  }
}
