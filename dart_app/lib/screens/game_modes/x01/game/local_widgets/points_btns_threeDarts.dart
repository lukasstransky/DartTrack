import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/point_btn_three_darts.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/revert_btn.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/submit_points_btn.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:developer';

class PointsBtnsThreeDarts extends StatelessWidget {
  const PointsBtnsThreeDarts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameX01 = Provider.of<GameX01>(context, listen: false);

    return Expanded(
      child: Column(
        children: [
          Container(
            height: 6.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(Utils.darken(
                            Theme.of(context).colorScheme.primary, 20)),
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: FittedBox(
                        child: Text(
                          gameX01.getCurrentThreeDarts[0],
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black,
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
                    margin: const EdgeInsets.only(
                      bottom: POINTS_BUTTON_MARGIN,
                      left: POINTS_BUTTON_MARGIN,
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(Utils.darken(
                            Theme.of(context).colorScheme.primary, 20)),
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: FittedBox(
                        child: Text(
                          gameX01.getCurrentThreeDarts[1],
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black,
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
                    margin: const EdgeInsets.only(
                      bottom: POINTS_BUTTON_MARGIN,
                      left: POINTS_BUTTON_MARGIN,
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(Utils.darken(
                            Theme.of(context).colorScheme.primary, 20)),
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: FittedBox(
                        child: Text(
                          gameX01.getCurrentThreeDarts[2],
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black,
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
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(
                        bottom: POINTS_BUTTON_MARGIN,
                        right: POINTS_BUTTON_MARGIN,
                      ),
                      child: RevertBtn()),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.checkIfPointBtnShouldBeDisabled("25")
                        ? PointBtnThreeDart(
                            point: "25",
                            activeBtn: true,
                          )
                        : PointBtnThreeDart(
                            point: "25",
                            activeBtn: false,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.checkIfPointBtnShouldBeDisabled("Bull")
                        ? PointBtnThreeDart(
                            point: "Bull",
                            activeBtn: true,
                          )
                        : PointBtnThreeDart(
                            point: "Bull",
                            activeBtn: false,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.primary),
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: FittedBox(
                        child: Text(
                          "Bust",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      onPressed: () {
                        gameX01.bust(context);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.checkIfPointBtnShouldBeDisabled("0")
                        ? PointBtnThreeDart(
                            point: "0",
                            activeBtn: true,
                          )
                        : PointBtnThreeDart(
                            point: "0",
                            activeBtn: false,
                          ),
                  ),
                ),
                if (!gameX01.getGameSettings.getAutomaticallySubmitPoints)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        bottom: POINTS_BUTTON_MARGIN,
                      ),
                      child: SubmitPointsBtn(),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.checkIfPointBtnShouldBeDisabled("1")
                        ? PointBtnThreeDart(
                            point: "1",
                            activeBtn: true,
                          )
                        : PointBtnThreeDart(
                            point: "1",
                            activeBtn: false,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.checkIfPointBtnShouldBeDisabled("2")
                        ? PointBtnThreeDart(
                            point: "2",
                            activeBtn: true,
                          )
                        : PointBtnThreeDart(
                            point: "2",
                            activeBtn: false,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.checkIfPointBtnShouldBeDisabled("3")
                        ? PointBtnThreeDart(
                            point: "3",
                            activeBtn: true,
                          )
                        : PointBtnThreeDart(
                            point: "3",
                            activeBtn: false,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.checkIfPointBtnShouldBeDisabled("4")
                        ? PointBtnThreeDart(
                            point: "4",
                            activeBtn: true,
                          )
                        : PointBtnThreeDart(
                            point: "4",
                            activeBtn: false,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.checkIfPointBtnShouldBeDisabled("5")
                        ? PointBtnThreeDart(
                            point: "5",
                            activeBtn: true,
                          )
                        : PointBtnThreeDart(
                            point: "5",
                            activeBtn: false,
                          ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.checkIfPointBtnShouldBeDisabled("6")
                        ? PointBtnThreeDart(
                            point: "6",
                            activeBtn: true,
                          )
                        : PointBtnThreeDart(
                            point: "6",
                            activeBtn: false,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.checkIfPointBtnShouldBeDisabled("7")
                        ? PointBtnThreeDart(
                            point: "7",
                            activeBtn: true,
                          )
                        : PointBtnThreeDart(
                            point: "7",
                            activeBtn: false,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.checkIfPointBtnShouldBeDisabled("8")
                        ? PointBtnThreeDart(
                            point: "8",
                            activeBtn: true,
                          )
                        : PointBtnThreeDart(
                            point: "8",
                            activeBtn: false,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.checkIfPointBtnShouldBeDisabled("9")
                        ? PointBtnThreeDart(
                            point: "9",
                            activeBtn: true,
                          )
                        : PointBtnThreeDart(
                            point: "9",
                            activeBtn: false,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.checkIfPointBtnShouldBeDisabled("10")
                        ? PointBtnThreeDart(
                            point: "10",
                            activeBtn: true,
                          )
                        : PointBtnThreeDart(
                            point: "10",
                            activeBtn: false,
                          ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.checkIfPointBtnShouldBeDisabled("11")
                        ? PointBtnThreeDart(
                            point: "11",
                            activeBtn: true,
                          )
                        : PointBtnThreeDart(
                            point: "11",
                            activeBtn: false,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.checkIfPointBtnShouldBeDisabled("12")
                        ? PointBtnThreeDart(
                            point: "12",
                            activeBtn: true,
                          )
                        : PointBtnThreeDart(
                            point: "12",
                            activeBtn: false,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.checkIfPointBtnShouldBeDisabled("13")
                        ? PointBtnThreeDart(
                            point: "13",
                            activeBtn: true,
                          )
                        : PointBtnThreeDart(
                            point: "13",
                            activeBtn: false,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.checkIfPointBtnShouldBeDisabled("14")
                        ? PointBtnThreeDart(
                            point: "14",
                            activeBtn: true,
                          )
                        : PointBtnThreeDart(
                            point: "14",
                            activeBtn: false,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.checkIfPointBtnShouldBeDisabled("15")
                        ? PointBtnThreeDart(
                            point: "15",
                            activeBtn: true,
                          )
                        : PointBtnThreeDart(
                            point: "15",
                            activeBtn: false,
                          ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.checkIfPointBtnShouldBeDisabled("16")
                        ? PointBtnThreeDart(
                            point: "16",
                            activeBtn: true,
                          )
                        : PointBtnThreeDart(
                            point: "16",
                            activeBtn: false,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.checkIfPointBtnShouldBeDisabled("17")
                        ? PointBtnThreeDart(
                            point: "17",
                            activeBtn: true,
                          )
                        : PointBtnThreeDart(
                            point: "17",
                            activeBtn: false,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.checkIfPointBtnShouldBeDisabled("18")
                        ? PointBtnThreeDart(
                            point: "18",
                            activeBtn: true,
                          )
                        : PointBtnThreeDart(
                            point: "18",
                            activeBtn: false,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.checkIfPointBtnShouldBeDisabled("19")
                        ? PointBtnThreeDart(
                            point: "19",
                            activeBtn: true,
                          )
                        : PointBtnThreeDart(
                            point: "19",
                            activeBtn: false,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.checkIfPointBtnShouldBeDisabled("20")
                        ? PointBtnThreeDart(
                            point: "20",
                            activeBtn: true,
                          )
                        : PointBtnThreeDart(
                            point: "20",
                            activeBtn: false,
                          ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        backgroundColor:
                            gameX01.getCurrentPointType == PointType.Single
                                ? MaterialStateProperty.all(Utils.darken(
                                    Theme.of(context).colorScheme.primary, 25))
                                : MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.primary),
                        overlayColor: gameX01.getCurrentPointType ==
                                PointType.Single
                            ? MaterialStateProperty.all(Colors.transparent)
                            : Utils.getColorOrPressed(
                                Theme.of(context).colorScheme.primary,
                                Utils.darken(
                                    Theme.of(context).colorScheme.primary, 15),
                              ),
                      ),
                      child: FittedBox(
                        child: const Text(
                          "Single",
                          style: TextStyle(
                            fontSize: THREE_DARTS_BUTTON_TEXT_SIZE,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      onPressed: () {
                        gameX01.setCurrentPointType = PointType.Single;
                        gameX01.notify();
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        backgroundColor:
                            gameX01.getCurrentPointType == PointType.Double
                                ? MaterialStateProperty.all(Utils.darken(
                                    Theme.of(context).colorScheme.primary, 25))
                                : MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.primary),
                        overlayColor: gameX01.getCurrentPointType ==
                                PointType.Double
                            ? MaterialStateProperty.all(Colors.transparent)
                            : Utils.getColorOrPressed(
                                Theme.of(context).colorScheme.primary,
                                Utils.darken(
                                    Theme.of(context).colorScheme.primary, 15),
                              ),
                      ),
                      child: FittedBox(
                        child: const Text(
                          "Double",
                          style: TextStyle(
                            fontSize: THREE_DARTS_BUTTON_TEXT_SIZE,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      onPressed: () {
                        gameX01.setCurrentPointType = PointType.Double;
                        gameX01.notify();
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        backgroundColor:
                            gameX01.getCurrentPointType == PointType.Tripple
                                ? MaterialStateProperty.all(Utils.darken(
                                    Theme.of(context).colorScheme.primary, 25))
                                : MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.primary),
                        overlayColor: gameX01.getCurrentPointType ==
                                PointType.Tripple
                            ? MaterialStateProperty.all(Colors.transparent)
                            : Utils.getColorOrPressed(
                                Theme.of(context).colorScheme.primary,
                                Utils.darken(
                                    Theme.of(context).colorScheme.primary, 15),
                              ),
                      ),
                      child: FittedBox(
                        child: const Text(
                          "Tripple",
                          style: TextStyle(
                            fontSize: THREE_DARTS_BUTTON_TEXT_SIZE,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      onPressed: () {
                        gameX01.setCurrentPointType = PointType.Tripple;
                        gameX01.notify();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
