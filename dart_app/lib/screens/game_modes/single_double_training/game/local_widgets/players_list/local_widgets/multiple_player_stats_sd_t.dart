import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_single_double_training.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MulitplePlayerStatsSingleDoubleTraining extends StatefulWidget {
  const MulitplePlayerStatsSingleDoubleTraining({Key? key}) : super(key: key);

  @override
  State<MulitplePlayerStatsSingleDoubleTraining> createState() =>
      _MulitplePlayerStatsSingleDoubleTrainingState();
}

class _MulitplePlayerStatsSingleDoubleTrainingState
    extends State<MulitplePlayerStatsSingleDoubleTraining> {
  @override
  void initState() {
    super.initState();
    newScrollControllerSingleDoubleTrainingPlayerEntries();
  }

  @override
  Widget build(BuildContext context) {
    final bool _isSingleMode =
        context.read<GameSingleDoubleTraining_P>().getMode ==
            GameMode.SingleTraining;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 0.5.h),
            child: Row(
              children: [
                Expanded(
                  child: HeaderText(textValue: 'Name'),
                ),
                Expanded(
                  child: HeaderText(textValue: 'Points'),
                ),
                if (_isSingleMode)
                  Expanded(
                    child: HeaderText(textValue: 'Singles'),
                  ),
                if (!_isSingleMode)
                  Expanded(
                    child: HeaderText(textValue: 'Doubles'),
                  ),
                if (_isSingleMode)
                  Expanded(
                    child: HeaderText(textValue: 'Tripples'),
                  ),
                Expanded(
                  child: HeaderText(textValue: 'Missed'),
                ),
              ],
            ),
          ),
          Divider(
            height: 0.1.h,
            thickness: 0.1.h,
            color: Colors.white,
          ),
          Selector<GameSingleDoubleTraining_P, List<PlayerOrTeamGameStats>>(
            selector: (_, gameScoreTraining_P) =>
                gameScoreTraining_P.getPlayerGameStatistics,
            shouldRebuild: (previous, next) => true,
            builder: (_, playerStats, __) => ListView.builder(
              scrollDirection: Axis.vertical,
              controller:
                  newScrollControllerSingleDoubleTrainingPlayerEntries(),
              itemCount: playerStats.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    PlayerEntry(
                      playerStats: playerStats[index]
                          as PlayerGameStatsSingleDoubleTraining,
                      isSingleMode: _isSingleMode,
                    ),
                    Divider(
                      height: 0.1.h,
                      thickness: 0.1.h,
                      color: Colors.white,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderText extends StatelessWidget {
  const HeaderText({
    Key? key,
    required this.textValue,
  }) : super(key: key);

  final String textValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.w,
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          textValue,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ValueText extends StatelessWidget {
  const ValueText({
    Key? key,
    required this.textValue,
  }) : super(key: key);

  final String textValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.w,
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          textValue,
          style: TextStyle(
            color: Utils.getTextColorDarken(context),
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class PlayerEntry extends StatelessWidget {
  const PlayerEntry({
    Key? key,
    required this.playerStats,
    required this.isSingleMode,
  }) : super(key: key);

  final PlayerGameStatsSingleDoubleTraining playerStats;
  final bool isSingleMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Utils.getBackgroundColorForPlayer(
          context, context.read<GameSingleDoubleTraining_P>(), playerStats),
      height: 5.h,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 1.w),
              child: ValueText(textValue: playerStats.getPlayer.getName),
            ),
          ),
          Expanded(
            child: ValueText(textValue: playerStats.getTotalPoints.toString()),
          ),
          if (isSingleMode)
            Expanded(
              child: ValueText(textValue: playerStats.getSingleHits.toString()),
            ),
          if (!isSingleMode)
            Expanded(
              child: ValueText(textValue: playerStats.getDoubleHits.toString()),
            ),
          if (isSingleMode)
            Expanded(
              child:
                  ValueText(textValue: playerStats.getTrippleHits.toString()),
            ),
          Expanded(
            child: ValueText(textValue: playerStats.getMissedHits.toString()),
          ),
        ],
      ),
    );
  }
}
