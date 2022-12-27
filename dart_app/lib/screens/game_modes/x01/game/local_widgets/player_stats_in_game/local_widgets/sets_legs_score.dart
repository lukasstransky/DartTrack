import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics_x01.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SetsLegsScore extends StatelessWidget {
  const SetsLegsScore({Key? key, required this.currPlayerOrTeamGameStatsX01})
      : super(key: key);

  final PlayerOrTeamGameStatisticsX01? currPlayerOrTeamGameStatsX01;

  @override
  Widget build(BuildContext context) {
    if (context.read<GameSettingsX01>().getSetsEnabled) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _legsSetsWidget(context, false),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: _legsSetsWidget(context, true),
          )
        ],
      );
    }
    return _legsSetsWidget(context, true);
  }

  SizedBox _legsSetsWidget(BuildContext context, bool showLegs) {
    return SizedBox(
      height: 4.h,
      child: ElevatedButton(
        onPressed: () => null,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            showLegs
                ? 'Legs: ${currPlayerOrTeamGameStatsX01!.getLegsWon.toString()}'
                : 'Sets: ${currPlayerOrTeamGameStatsX01!.getSetsWon.toString()}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
            ),
          ),
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
          ),
          backgroundColor: Utils.getPrimaryMaterialStateColorDarken(context),
        ),
      ),
    );
  }
}
