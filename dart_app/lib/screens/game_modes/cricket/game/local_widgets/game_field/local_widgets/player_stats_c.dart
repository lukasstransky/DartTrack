import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PlayerOrTeamStatsCricket extends StatelessWidget {
  const PlayerOrTeamStatsCricket({
    Key? key,
    required this.evenPlayersOrTeams,
    required this.playerOrTeamGameStatistics,
  }) : super(key: key);

  final bool evenPlayersOrTeams;
  final dynamic playerOrTeamGameStatistics;

  @override
  Widget build(BuildContext context) {
    final GameSettingsCricket_P _gameSettingsCricket =
        context.read<GameSettingsCricket_P>();
    final GameCricket_P gameCricket = context.read<GameCricket_P>();
    final int _halfLength = playerOrTeamGameStatistics.length ~/ 2;
    final TextStyle _textStyle = TextStyle(
      color: Colors.white,
      fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
    );

    return Row(
      children: [
        if (!evenPlayersOrTeams)
          Container(
            width: 20.w,
            decoration: BoxDecoration(
              border: Border(
                left: Utils.isLandscape(context) &&
                        gameCricket.getSafeAreaPadding.left > 0
                    ? BorderSide(
                        width: GENERAL_BORDER_WIDTH.w,
                        color: Utils.getPrimaryColorDarken(context),
                      )
                    : BorderSide.none,
              ),
            ),
            child: Container(
              padding: EdgeInsets.only(top: 0.5.h, bottom: 0.5.h),
            ),
          ),
        for (int i = 0; i < playerOrTeamGameStatistics.length; i++) ...[
          if (evenPlayersOrTeams && i == _halfLength)
            Container(
              width: 20.w,
              padding: EdgeInsets.only(top: 0.5.h, bottom: 0.5.h),
            ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 0.5.h, bottom: 0.5.h),
              decoration: BoxDecoration(
                border: Border(
                  left: Utils.showLeftBorder(_gameSettingsCricket, i)
                      ? BorderSide(
                          width: GENERAL_BORDER_WIDTH.w,
                          color: Utils.getPrimaryColorDarken(context),
                        )
                      : BorderSide.none,
                  right: Utils.showRightBorder(_gameSettingsCricket, i)
                      ? BorderSide(
                          width: GENERAL_BORDER_WIDTH.w,
                          color: Utils.getPrimaryColorDarken(context),
                        )
                      : BorderSide.none,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_gameSettingsCricket.getSetsEnabled)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Sets:',
                              style: _textStyle,
                            ),
                          ),
                        ),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '${playerOrTeamGameStatistics[i].getSetsWon.toString()}',
                              style: _textStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (_gameSettingsCricket.getSetsEnabled ||
                      _gameSettingsCricket.getLegs > 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Legs:',
                              style: _textStyle,
                            ),
                          ),
                        ),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '${playerOrTeamGameStatistics[i].getLegsWon.toString()}',
                              style: _textStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'MPR:',
                            style: _textStyle,
                          ),
                        ),
                      ),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${playerOrTeamGameStatistics[i].getMarksPerRound()}',
                            style: _textStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
