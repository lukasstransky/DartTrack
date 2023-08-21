import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/multiple_player_team_stats/multiple_player_team_stats_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/round/point_btns_round_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/two_player_team_stats_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/point_btns_three_darts_x01.dart';

import 'package:dart_app/utils/app_bars/x01/custom_app_bar_x01_game.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class GameX01 extends StatefulWidget {
  static const routeName = '/gameX01';

  @override
  GameX01State createState() => GameX01State();
}

class GameX01State extends State<GameX01> {
  @override
  didChangeDependencies() {
    final Map arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    // only init game for new game, not for open game
    if (arguments.isNotEmpty && !arguments['openGame']) {
      context.read<GameX01_P>().init(context.read<GameSettingsX01_P>());
    }
    super.didChangeDependencies();
  }

  _getTwoOrMultiplePlayerTeamStatsView(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01_P =
        context.read<GameSettingsX01_P>();
    final bool isSingleMode =
        gameSettingsX01_P.getSingleOrTeam == SingleOrTeamEnum.Single;
    final bool isSingleGameWithTwoPlayers =
        isSingleMode && gameSettingsX01_P.getPlayers.length == 2;
    final bool isTeamGameWithTwoTeams =
        !isSingleMode && gameSettingsX01_P.getTeams.length == 2;

    if (isSingleGameWithTwoPlayers || isTeamGameWithTwoTeams) {
      return TwoPlayerTeamStatsX01(
        isSingleMode: isSingleGameWithTwoPlayers ? true : false,
      );
    }

    return MultiplePlayerTeamStatsX01(
      isSingleMode: isSingleMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isTeamMode = context.read<GameSettingsX01_P>().getSingleOrTeam ==
        SingleOrTeamEnum.Team;

    return WillPopScope(
      onWillPop: () async => false, // ignore gestures
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBarX01Game(),
        body: Selector<GameX01_P, bool>(
          selector: (_, game) => game.getShowLoadingSpinner,
          builder: (_, showLoadingSpinner, __) => showLoadingSpinner
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Column(
                  children: [
                    _getTwoOrMultiplePlayerTeamStatsView(context),
                    if (isTeamMode) PlayerToThrowForTeamMode(context: context),
                    Selector<GameSettingsX01_P, InputMethod>(
                      selector: (_, gameSettingsX01) =>
                          gameSettingsX01.getInputMethod,
                      builder: (_, inputMethod, __) =>
                          inputMethod == InputMethod.Round
                              ? PointBtnsRoundX01()
                              : PointsBtnsThreeDartsX01(),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class PlayerToThrowForTeamMode extends StatelessWidget {
  const PlayerToThrowForTeamMode({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5.h,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Utils.getPrimaryColorDarken(context),
            width: GENERAL_BORDER_WIDTH.w,
          ),
        ),
      ),
      padding: EdgeInsets.only(left: 13.w),
      child: Row(
        children: [
          Text(
            'Player to throw: ',
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
            ),
          ),
          Selector<GameX01_P, Player>(
            selector: (_, gameX01) {
              final currentPlayer = gameX01.getCurrentPlayerToThrow;
              return currentPlayer != null ? currentPlayer : Player(name: '');
            },
            builder: (_, currentPlayerToThrow, __) => Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  padding: EdgeInsets.only(right: 2.w),
                  child: Text(
                    currentPlayerToThrow.getName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          Theme.of(context).textTheme.titleSmall!.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
