import 'package:dart_app/constants.dart';
import 'package:dart_app/models/firestore/stats_firestore_x01_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class StatsScoreTrainingBtn extends StatelessWidget {
  const StatsScoreTrainingBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      child: ElevatedButton(
        onPressed: () {
          context.loaderOverlay.show();
          context.read<StatsFirestoreX01_P>().notify();
          Navigator.of(context).pushNamed('/statsPerGameList',
              arguments: {'mode': 'Score training'});
          context.loaderOverlay.hide();

          context.read<StatsFirestoreX01_P>().notify();
        },
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Score training',
            style: TextStyle(
              fontSize: 12.sp,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        style: ButtonStyle(
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          overlayColor: Utils.getColorOrPressed(
            Theme.of(context).colorScheme.primary,
            Utils.darken(Theme.of(context).colorScheme.primary, 15),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(
            Utils.darken(Theme.of(context).colorScheme.primary, GENERAL_DARKEN),
          ),
        ),
      ),
    );
  }
}
