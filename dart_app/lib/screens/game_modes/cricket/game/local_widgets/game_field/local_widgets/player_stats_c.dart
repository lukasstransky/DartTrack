import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
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
    final int _halfLength = playerOrTeamGameStatistics.length ~/ 2;
    final TextStyle _textStyle = TextStyle(
      color: Colors.white,
      fontSize: 10.sp,
    );
    final int _width = 11;

    return Container(
      height: _getHeight(_gameSettingsCricket),
      child: Row(
        children: [
          if (!evenPlayersOrTeams)
            Container(
              width: 20.w,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: GENERAL_BORDER_WIDTH.w,
                    color: Utils.getPrimaryColorDarken(context),
                  ),
                  right: BorderSide(
                    width: GENERAL_BORDER_WIDTH.w,
                    color: Utils.getPrimaryColorDarken(context),
                  ),
                ),
              ),
            ),
          for (int i = 0; i < playerOrTeamGameStatistics.length; i++) ...[
            if (evenPlayersOrTeams && i == _halfLength)
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: GENERAL_BORDER_WIDTH.w,
                      color: Utils.getPrimaryColorDarken(context),
                    ),
                    right: BorderSide(
                      width: GENERAL_BORDER_WIDTH.w,
                      color: Utils.getPrimaryColorDarken(context),
                    ),
                    left: BorderSide(
                      width: GENERAL_BORDER_WIDTH.w,
                      color: Utils.getPrimaryColorDarken(context),
                    ),
                  ),
                ),
                width: 20.w,
              ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  left: _getPaddingValue(_gameSettingsCricket),
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: GENERAL_BORDER_WIDTH.w,
                      color: Utils.getPrimaryColorDarken(context),
                    ),
                    left: Utils.showLeftBorderCricket(i, _gameSettingsCricket)
                        ? BorderSide(
                            width: GENERAL_BORDER_WIDTH.w,
                            color: Utils.getPrimaryColorDarken(context),
                          )
                        : BorderSide.none,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_gameSettingsCricket.getSetsEnabled)
                      Row(
                        children: [
                          Container(
                            width: _width.w,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Sets:',
                                style: _textStyle,
                              ),
                            ),
                          ),
                          Flexible(
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
                        children: [
                          Container(
                            width: _width.w,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Legs:',
                                style: _textStyle,
                              ),
                            ),
                          ),
                          Flexible(
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
                    Padding(
                      padding: EdgeInsets.only(right: 0.5.w),
                      child: Row(
                        children: [
                          Container(
                            width: _width.w,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'MPR:',
                                style: _textStyle,
                              ),
                            ),
                          ),
                          Flexible(
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
                    ),
                  ],
                ),
              ),
            )
          ],
        ],
      ),
    );
  }

  _getPaddingValue(GameSettingsCricket_P gameSettingsCricket) {
    if (gameSettingsCricket.getSingleOrTeam == SingleOrTeamEnum.Single) {
      if (gameSettingsCricket.getPlayers.length == 2) {
        return 12.w;
      } else if (gameSettingsCricket.getPlayers.length == 3) {
        return 6.w;
      }
    } else {
      if (gameSettingsCricket.getTeams.length == 2) {
        return 12.w;
      } else if (gameSettingsCricket.getTeams.length == 3) {
        return 6.w;
      }
    }
    return 1.w;
  }

  _getHeight(GameSettingsCricket_P gameSettingsCricket) {
    if (!gameSettingsCricket.getSetsEnabled &&
        gameSettingsCricket.getLegs == 1) {
      // only MRP is displayed
      return 4.h;
    } else if (!gameSettingsCricket.getSetsEnabled &&
        gameSettingsCricket.getLegs > 1) {
      // MPR + legs is displayed
      return 6.h;
    } else if (gameSettingsCricket.getSetsEnabled &&
        gameSettingsCricket.getLegs > 1) {
      // MPR + legs + sets is displayed
      return 8.h;
    }
  }
}
