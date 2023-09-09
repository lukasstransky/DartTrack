import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_cricket.dart';
import 'package:dart_app/screens/game_modes/cricket/game/local_widgets/game_field/local_widgets/fields_to_hit_c.dart';
import 'package:dart_app/screens/game_modes/cricket/game/local_widgets/game_field/local_widgets/number_scores_for_player.dart';
import 'package:dart_app/screens/game_modes/cricket/game/local_widgets/game_field/local_widgets/player_names_and_scores_c.dart';
import 'package:dart_app/screens/game_modes/cricket/game/local_widgets/game_field/local_widgets/player_stats_c.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class GameFieldCricket extends StatelessWidget {
  const GameFieldCricket({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameCricket_P _gameCricket = context.read<GameCricket_P>();
    final GameSettingsCricket_P _gameSettingsCricket =
        context.read<GameSettingsCricket_P>();
    final _playerOrTeamGameStatistics = Utils.getPlayersOrTeamStatsList(
        _gameCricket,
        _gameSettingsCricket.getSingleOrTeam == SingleOrTeamEnum.Team);
    final int _halfLength = _playerOrTeamGameStatistics.length ~/ 2;
    final bool _evenPlayersOrTeams =
        _playerOrTeamGameStatistics.length % 2 == 0;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: shouldDisplayLeftBorder(
                  _gameSettingsCricket, _gameCricket, context)
              ? BorderSide(
                  width: GENERAL_BORDER_WIDTH.w,
                  color: Utils.getPrimaryColorDarken(context),
                )
              : BorderSide.none,
          bottom: _gameCricket.getSafeAreaPadding.bottom > 0 &&
                  Utils.isLandscape(context)
              ? BorderSide(
                  width: GENERAL_BORDER_WIDTH.w,
                  color: Utils.getPrimaryColorDarken(context),
                )
              : BorderSide.none,
        ),
      ),
      child: Selector<GameCricket_P, SelectorModel>(
        selector: (_, gameCricket) => SelectorModel(
          playerStats: gameCricket.getPlayerGameStatistics,
          teamStats: gameCricket.getTeamGameStatistics,
        ),
        shouldRebuild: (previous, next) => true,
        builder: (_, selectorModel, __) => Column(
          children: [
            PlayerOrTeamNamesAndScores(
              evenPlayersOrTeams: _evenPlayersOrTeams,
              playerOrTeamGameStatistics: _playerOrTeamGameStatistics,
            ),
            wrapExpandedIfLandscape(
              context,
              Container(
                height: Utils.isLandscape(context)
                    ? null
                    : _calcHeight(_gameSettingsCricket),
                child: Row(
                  children: [
                    if (!_evenPlayersOrTeams)
                      FieldsToHit(oddPlayersOrTeams: true),
                    for (int i = 0;
                        i < _playerOrTeamGameStatistics.length ~/ 2;
                        i++)
                      NumberScoresForPlayerOrTeam(
                        playerOrTeamStats: _playerOrTeamGameStatistics[i]
                            as PlayerOrTeamGameStatsCricket,
                      ),
                    if (_evenPlayersOrTeams) FieldsToHit(),
                    for (int i = _halfLength;
                        i < _playerOrTeamGameStatistics.length;
                        i++)
                      NumberScoresForPlayerOrTeam(
                        playerOrTeamStats: _playerOrTeamGameStatistics[i]
                            as PlayerOrTeamGameStatsCricket,
                      ),
                  ],
                ),
              ),
            ),
            PlayerOrTeamStatsCricket(
              evenPlayersOrTeams: _evenPlayersOrTeams,
              playerOrTeamGameStatistics: _playerOrTeamGameStatistics,
            ),
          ],
        ),
      ),
    );
  }

  Widget wrapExpandedIfLandscape(BuildContext context, Widget child) {
    return Utils.isLandscape(context) ? Expanded(child: child) : child;
  }

  double _calcHeight(GameSettingsCricket_P gameSettingsCricket) {
    if (gameSettingsCricket.getSingleOrTeam == SingleOrTeamEnum.Team &&
        gameSettingsCricket.getSetsEnabled) {
      return 40.h;
    } else if (gameSettingsCricket.getSingleOrTeam == SingleOrTeamEnum.Single &&
        gameSettingsCricket.getSetsEnabled) {
      return 42.h;
    }
    return 45.h;
  }

  bool shouldDisplayLeftBorder(GameSettingsCricket_P gameSettingsCricket,
      GameCricket_P gameCricket, BuildContext context) {
    if (gameCricket.getSafeAreaPadding.left > 0 && Utils.isLandscape(context)) {
      if (gameSettingsCricket.getSingleOrTeam == SingleOrTeamEnum.Single) {
        return gameSettingsCricket.getPlayers.length == 2 ||
            gameSettingsCricket.getPlayers.length == 4;
      }
      return gameSettingsCricket.getTeams.length == 2 ||
          gameSettingsCricket.getTeams.length == 4;
    }

    return false;
  }
}

class SelectorModel {
  final List<PlayerOrTeamGameStats> playerStats;
  final List<PlayerOrTeamGameStats> teamStats;

  SelectorModel({
    required this.playerStats,
    required this.teamStats,
  });
}
