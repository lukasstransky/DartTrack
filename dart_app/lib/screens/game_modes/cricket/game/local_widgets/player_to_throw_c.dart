import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PlayerToThrow extends StatelessWidget {
  const PlayerToThrow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isTeamMode =
        context.read<GameSettingsCricket_P>().getSingleOrTeam ==
            SingleOrTeamEnum.Team;

    return isTeamMode
        ? Container(
            height: 5.h,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: GENERAL_BORDER_WIDTH.w,
                ),
                right:
                    context.read<GameCricket_P>().getSafeAreaPadding.right > 0
                        ? BorderSide(
                            color: Utils.getPrimaryColorDarken(context),
                            width: GENERAL_BORDER_WIDTH.w,
                          )
                        : BorderSide.none,
                left: Utils.isLandscape(context)
                    ? BorderSide(
                        color: Utils.getPrimaryColorDarken(context),
                        width: GENERAL_BORDER_WIDTH.w,
                      )
                    : BorderSide.none,
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
                Selector<GameCricket_P, Player>(
                  selector: (_, gameX01) {
                    final currentPlayer = gameX01.getCurrentPlayerToThrow;
                    return currentPlayer != null
                        ? currentPlayer
                        : Player(name: '');
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
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : SizedBox.shrink();
  }
}
