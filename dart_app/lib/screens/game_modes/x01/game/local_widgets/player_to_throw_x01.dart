import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PlayerToThrowX01 extends StatelessWidget {
  const PlayerToThrowX01({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameX01_P gameX01 = context.read<GameX01_P>();
    final EdgeInsets safeAreaPadding = gameX01.getSafeAreaPadding;

    return Selector<GameX01_P, Player>(
      selector: (_, gameX01) => gameX01.getCurrentPlayerToThrow,
      builder: (_, currentPlayerToThrow, __) => Container(
        alignment: Alignment.center,
        height: 5.h,
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
              color: Colors.white,
            ),
            children: [
              TextSpan(
                text: 'Player to throw: ',
              ),
              TextSpan(
                text: gameX01.getCurrentPlayerToThrow.getName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: GENERAL_BORDER_WIDTH.w,
              color: Utils.getPrimaryColorDarken(context),
            ),
            left: Utils.isLandscape(context)
                ? BorderSide(
                    color: Utils.getPrimaryColorDarken(context),
                    width: GENERAL_BORDER_WIDTH.w,
                  )
                : BorderSide.none,
            right: Utils.isLandscape(context) && safeAreaPadding.right > 0
                ? BorderSide(
                    color: Utils.getPrimaryColorDarken(context),
                    width: GENERAL_BORDER_WIDTH.w,
                  )
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
