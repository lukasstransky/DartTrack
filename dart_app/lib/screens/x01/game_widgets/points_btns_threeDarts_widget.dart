import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_x01_model.dart';
import 'package:dart_app/other/utils.dart';
import 'package:dart_app/screens/x01/game_widgets/point_btn_round_widget.dart';
import 'package:dart_app/screens/x01/game_widgets/point_btn_three_darts_widget.dart';
import 'package:dart_app/screens/x01/game_widgets/revert_btn_widget.dart';
import 'package:dart_app/screens/x01/game_widgets/submit_points_btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:developer';

class PointsBtnsThreeDartsWidget extends StatelessWidget {
  const PointsBtnsThreeDartsWidget({Key? key}) : super(key: key);

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
                      child: RevertBtnWidget()),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.checkIfPointBtnShouldBeDisabled("25")
                        ? PointBtnThreeDartwWidget(
                            point: "25",
                            activeBtn: true,
                          )
                        : PointBtnThreeDartwWidget(
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
                        ? PointBtnThreeDartwWidget(
                            point: "Bull",
                            activeBtn: true,
                          )
                        : PointBtnThreeDartwWidget(
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
                        ? PointBtnThreeDartwWidget(
                            point: "0",
                            activeBtn: true,
                          )
                        : PointBtnThreeDartwWidget(
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
                      child: SubmitPointsBtnWidget(),
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
                        ? PointBtnThreeDartwWidget(
                            point: "1",
                            activeBtn: true,
                          )
                        : PointBtnThreeDartwWidget(
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
                        ? PointBtnThreeDartwWidget(
                            point: "2",
                            activeBtn: true,
                          )
                        : PointBtnThreeDartwWidget(
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
                        ? PointBtnThreeDartwWidget(
                            point: "3",
                            activeBtn: true,
                          )
                        : PointBtnThreeDartwWidget(
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
                        ? PointBtnThreeDartwWidget(
                            point: "4",
                            activeBtn: true,
                          )
                        : PointBtnThreeDartwWidget(
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
                        ? PointBtnThreeDartwWidget(
                            point: "5",
                            activeBtn: true,
                          )
                        : PointBtnThreeDartwWidget(
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
                        ? PointBtnThreeDartwWidget(
                            point: "6",
                            activeBtn: true,
                          )
                        : PointBtnThreeDartwWidget(
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
                        ? PointBtnThreeDartwWidget(
                            point: "7",
                            activeBtn: true,
                          )
                        : PointBtnThreeDartwWidget(
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
                        ? PointBtnThreeDartwWidget(
                            point: "8",
                            activeBtn: true,
                          )
                        : PointBtnThreeDartwWidget(
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
                        ? PointBtnThreeDartwWidget(
                            point: "9",
                            activeBtn: true,
                          )
                        : PointBtnThreeDartwWidget(
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
                        ? PointBtnThreeDartwWidget(
                            point: "10",
                            activeBtn: true,
                          )
                        : PointBtnThreeDartwWidget(
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
                        ? PointBtnThreeDartwWidget(
                            point: "11",
                            activeBtn: true,
                          )
                        : PointBtnThreeDartwWidget(
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
                        ? PointBtnThreeDartwWidget(
                            point: "12",
                            activeBtn: true,
                          )
                        : PointBtnThreeDartwWidget(
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
                        ? PointBtnThreeDartwWidget(
                            point: "13",
                            activeBtn: true,
                          )
                        : PointBtnThreeDartwWidget(
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
                        ? PointBtnThreeDartwWidget(
                            point: "14",
                            activeBtn: true,
                          )
                        : PointBtnThreeDartwWidget(
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
                        ? PointBtnThreeDartwWidget(
                            point: "15",
                            activeBtn: true,
                          )
                        : PointBtnThreeDartwWidget(
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
                        ? PointBtnThreeDartwWidget(
                            point: "16",
                            activeBtn: true,
                          )
                        : PointBtnThreeDartwWidget(
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
                        ? PointBtnThreeDartwWidget(
                            point: "17",
                            activeBtn: true,
                          )
                        : PointBtnThreeDartwWidget(
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
                        ? PointBtnThreeDartwWidget(
                            point: "18",
                            activeBtn: true,
                          )
                        : PointBtnThreeDartwWidget(
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
                        ? PointBtnThreeDartwWidget(
                            point: "19",
                            activeBtn: true,
                          )
                        : PointBtnThreeDartwWidget(
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
                        ? PointBtnThreeDartwWidget(
                            point: "20",
                            activeBtn: true,
                          )
                        : PointBtnThreeDartwWidget(
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
                            : Utils.getColor(
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
                            : Utils.getColor(
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
                            : Utils.getColor(
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
