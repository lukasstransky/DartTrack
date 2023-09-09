import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PlayerToThrowFromTeam extends StatelessWidget {
  const PlayerToThrowFromTeam({Key? key}) : super(key: key);

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
          right: context.read<GameX01_P>().getSafeAreaPadding.right > 0
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
