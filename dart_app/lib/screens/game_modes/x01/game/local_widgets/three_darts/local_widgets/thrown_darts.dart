import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ThrownDarts extends StatelessWidget {
  const ThrownDarts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameX01_P gameX01 = context.read<GameX01_P>();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: 3,
                ),
                top: BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: 3,
                ),
              ),
            ),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(
                    Utils.darken(Theme.of(context).colorScheme.primary, 20)),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: FittedBox(
                child: Text(
                  gameX01.getCurrentThreeDarts[0],
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: () {
                null;
              },
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: 3,
                ),
              ),
            ),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(
                    Utils.darken(Theme.of(context).colorScheme.primary, 20)),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: FittedBox(
                child: Text(
                  gameX01.getCurrentThreeDarts[1],
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: () {
                null;
              },
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: 3,
                ),
                left: BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: 3,
                ),
              ),
            ),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(
                    Utils.darken(Theme.of(context).colorScheme.primary, 20)),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: FittedBox(
                child: Text(
                  gameX01.getCurrentThreeDarts[2],
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: () {
                null;
              },
            ),
          ),
        ),
      ],
    );
  }
}
