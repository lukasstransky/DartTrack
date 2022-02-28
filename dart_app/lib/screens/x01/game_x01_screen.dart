import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_x01_model.dart';

import 'package:dart_app/models/game_settings/game_settings_x01_model.dart';
import 'package:dart_app/other/custom_app_bar_game_x01.dart';
import 'package:dart_app/other/utils.dart';
import 'package:dart_app/screens/x01/game_widgets/player_stats_in_game_widget.dart';
import 'package:dart_app/screens/x01/game_widgets/points_btns_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:developer';

class GameX01Screen extends StatefulWidget {
  static const routeName = "/gameX01";

  const GameX01Screen({Key? key}) : super(key: key);

  @override
  _GameX01ScreenState createState() => _GameX01ScreenState();
}

class _GameX01ScreenState extends State<GameX01Screen> {
  @override
  void initState() {
    Provider.of<GameX01>(context, listen: false)
        .init(Provider.of<GameSettingsX01>(context, listen: false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);
    final gameX01 = Provider.of<GameX01>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarGameX01(gameSettingsX01),
      body: Column(
        children: [
          Container(
            height: 40.h,
            child: Column(
              children: [
                Container(
                  height: 34.h,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: gameSettingsX01.getPlayers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PlayerStatsInGame(
                        playerGameStatisticsX01:
                            gameX01.getPlayerGameStatistics[index],
                      );
                    },
                  ),
                ),
                Container(
                  height: 6.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: 25.w,
                        padding: const EdgeInsets.all(5),
                        child: Selector<GameX01, bool>(
                          selector: (_, gameX01) => gameX01.getRevertPossible,
                          builder: (_, revertPossible, __) => ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                shadowColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                backgroundColor: revertPossible
                                    ? MaterialStateProperty.all(Colors.red)
                                    : MaterialStateProperty.all(
                                        Utils.darken(Colors.red, 15)),
                                overlayColor: revertPossible
                                    ? MaterialStateProperty.all(
                                        Utils.darken(Colors.red, 15))
                                    : MaterialStateProperty.all(
                                        Colors.transparent),
                              ),
                              child: Icon(Icons.undo, color: Colors.black),
                              onPressed: () {
                                if (revertPossible) {
                                  gameX01.revertPoints();
                                }
                              }),
                        ),
                      ),
                      Container(
                        width: 50.w,
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          child: Center(
                            child: Selector<GameX01, String>(
                              selector: (_, gameX01) =>
                                  gameX01.getCurrentPointsSelected,
                              builder: (_, currentPointsSelected, __) => Center(
                                child: Text(
                                  currentPointsSelected,
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 25.w,
                        padding: const EdgeInsets.all(5),
                        child: Selector<GameX01, String>(
                          selector: (_, gameX01) =>
                              gameX01.getCurrentPointsSelected,
                          builder: (_, currentPointsSelected, __) =>
                              ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero,
                                      ),
                                    ),
                                    backgroundColor: currentPointsSelected
                                                .isNotEmpty &&
                                            currentPointsSelected != "Points"
                                        ? MaterialStateProperty.all(
                                            Colors.green)
                                        : MaterialStateProperty.all(
                                            Utils.darken(Colors.green, 15)),
                                    shadowColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    overlayColor: currentPointsSelected
                                                .isNotEmpty &&
                                            currentPointsSelected != "Points"
                                        ? MaterialStateProperty.all(
                                            Utils.darken(Colors.green, 15))
                                        : MaterialStateProperty.all(
                                            Colors.transparent),
                                  ),
                                  child: Icon(Icons.arrow_forward,
                                      color: Colors.black),
                                  onPressed: () {
                                    if (currentPointsSelected.isNotEmpty &&
                                        currentPointsSelected != "Points") {
                                      gameX01
                                          .submitPoints(currentPointsSelected);
                                    }
                                  }),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          PointsBtnsWidget(),
        ],
      ),
    );
  }
}
