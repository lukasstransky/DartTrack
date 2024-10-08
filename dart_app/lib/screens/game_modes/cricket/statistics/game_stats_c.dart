import 'dart:io';

import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/user_p.dart';
import 'package:dart_app/screens/game_modes/cricket/statistics/local_widgets/main_stats_c.dart';
import 'package:dart_app/screens/game_modes/cricket/statistics/local_widgets/points_per_number_c.dart';
import 'package:dart_app/screens/game_modes/shared/game_stats/player_or_team_names.dart';
import 'package:dart_app/screens/game_modes/shared/game_stats/show_teams_or_players_stats_btn.dart';
import 'package:dart_app/utils/ad_management/banner_ad_widget.dart';

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
  // testing ads
  // final String _bannerAdUnitId = Platform.isAndroid
  //     ? 'ca-app-pub-8582367743573228/5521925033'
  //     : 'ca-app-pub-8582367743573228/6208320749';
  // real ads
  final String _bannerAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-8582367743573228/5521925033'
      : 'ca-app-pub-8582367743573228/6208320749';

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
      body: SafeArea(
        child: Column(
          children: [
            if (context.read<User_P>().getAdsEnabled)
              Container(
                padding: EdgeInsets.only(bottom: 0.5.h),
                child: BannerAdWidget(
                  bannerAdUnitId: _bannerAdUnitId,
                  bannerAdEnum: BannerAdEnum.CricketStatsScreen,
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Text(
                      _getHeader(context.read<GameSettingsCricket_P>()),
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleSmall!.fontSize! *
                                0.9,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      alignment:
                          Utils.isLandscape(context) ? Alignment.center : null,
                      padding: EdgeInsets.only(
                        top: 0.5.h,
                        bottom: 1.h,
                      ),
                      child: Text(
                        _game!.getFormattedDateTime(),
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyMedium!.fontSize,
                          fontWeight: FontWeight.bold,
                          color: Utils.getTextColorDarken(context),
                        ),
                      ),
                    ),
                    SafeArea(
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
                              if (_game!.getGameSettings.getMode !=
                                  CricketMode.NoScore)
                                PointsPerNumberCricket(game: _game!),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getHeader(GameSettingsCricket_P settings) {
    final String bestOfOrFirstToString =
        settings.getBestOfOrFirstTo == BestOfOrFirstToEnum.FirstTo
            ? 'First to '
            : 'Best of ';
    final String setsString =
        settings.getSetsEnabled ? '${settings.getSets} sets ' : '';
    final String legsString =
        '${settings.getLegs} ${settings.getLegs == 1 ? 'leg' : 'legs'}';

    return '${bestOfOrFirstToString}${setsString}${legsString} - ${settings.getMode.name}';
  }
}
