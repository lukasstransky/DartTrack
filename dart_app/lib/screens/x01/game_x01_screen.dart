import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_x01_model.dart';

import 'package:dart_app/models/game_settings/game_settings_x01_model.dart';
import 'package:dart_app/other/custom_app_bar_game_x01.dart';
import 'package:dart_app/other/utils.dart';
import 'package:dart_app/screens/x01/game_widgets/player_stats_in_game_widget.dart';
import 'package:dart_app/screens/x01/game_widgets/points_btns_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:developer';

class GameX01Screen extends StatefulWidget {
  static const routeName = "/gameX01";

  const GameX01Screen({Key? key}) : super(key: key);

  @override
  GameX01ScreenState createState() => GameX01ScreenState();
}

class GameX01ScreenState extends State<GameX01Screen> {
  @override
  void initState() {
    Provider.of<GameX01>(context, listen: false)
        .init(Provider.of<GameSettingsX01>(context, listen: false));
    super.initState();
  }

  //shows a dialog for selecting the amount of checkout possibilities for the current throw
  showDialogForCheckout(GameX01 gameX01, int checkoutPossibilities,
      String currentPointsSelected) {
    int selectedCheckoutCount =
        gameX01.finishedLegSetOrGame(currentPointsSelected) ? 1 : 0;
    int selectedFinishCount = gameX01.isDoubleField(currentPointsSelected)
        ? 1
        : 2; //how many darts a player needed for finising

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: gameX01.getGameSettings.getEnableCheckoutCounting
            ? Text("Checkout Counting")
            : Text("Finish Counting"),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (gameX01.getGameSettings.getEnableCheckoutCounting)
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Darts on Double:")),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (gameX01.getGameSettings.getEnableCheckoutCounting) ...[
                      if (!gameX01.finishedLegSetOrGame(currentPointsSelected))
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(5),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() => selectedCheckoutCount = 0);
                              },
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: const Text("0"),
                              ),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                ),
                                backgroundColor: selectedCheckoutCount == 0
                                    ? MaterialStateProperty.all(
                                        Theme.of(context).colorScheme.primary)
                                    : MaterialStateProperty.all<Color>(
                                        Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() => selectedCheckoutCount = 1);
                            },
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: const Text("1"),
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                              ),
                              backgroundColor: selectedCheckoutCount == 1
                                  ? MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.primary)
                                  : MaterialStateProperty.all<Color>(
                                      Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      if (checkoutPossibilities >= 2)
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(5),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() => selectedCheckoutCount = 2);
                              },
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: const Text("2"),
                              ),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                ),
                                backgroundColor: selectedCheckoutCount == 2
                                    ? MaterialStateProperty.all(
                                        Theme.of(context).colorScheme.primary)
                                    : MaterialStateProperty.all<Color>(
                                        Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      if (checkoutPossibilities == 3)
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(5),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() => selectedCheckoutCount = 3);
                              },
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: const Text("3"),
                              ),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                ),
                                backgroundColor: selectedCheckoutCount == 3
                                    ? MaterialStateProperty.all(
                                        Theme.of(context).colorScheme.primary)
                                    : MaterialStateProperty.all<Color>(
                                        Colors.grey),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
                if (gameX01.finishedLegSetOrGame(currentPointsSelected)) ...[
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Darts for Finish:")),
                  Row(
                    children: [
                      if (gameX01.isDoubleField(currentPointsSelected))
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(5),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() => selectedFinishCount = 1);
                              },
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: const Text("1"),
                              ),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                ),
                                backgroundColor: selectedFinishCount == 1
                                    ? MaterialStateProperty.all(
                                        Theme.of(context).colorScheme.primary)
                                    : MaterialStateProperty.all<Color>(
                                        Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() => selectedFinishCount = 2);
                            },
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: const Text("2"),
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                              ),
                              backgroundColor: selectedFinishCount == 2
                                  ? MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.primary)
                                  : MaterialStateProperty.all<Color>(
                                      Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() => selectedFinishCount = 3);
                            },
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: const Text("3"),
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                              ),
                              backgroundColor: selectedFinishCount == 3
                                  ? MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.primary)
                                  : MaterialStateProperty.all<Color>(
                                      Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              gameX01.setCurrentPointsSelected = "Points";
              gameX01.notify();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              gameX01.addToCheckoutCount(selectedCheckoutCount);
              gameX01.submitPoints(currentPointsSelected);
              Navigator.of(context).pop();
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
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
                                    //double in -> check for 1, 3, 5 -> invalid
                                    if (gameX01.getGameSettings.getModeIn ==
                                            SingleOrDouble.DoubleField &&
                                        gameX01
                                            .checkIfInvalidDoubleInPointsSubmitted(
                                                currentPointsSelected)) {
                                      Fluttertoast.showToast(
                                          msg: "Invalid Score for Double In!");
                                      gameX01.setCurrentPointsSelected =
                                          "Points";
                                      gameX01.notify();
                                    } else {
                                      if (currentPointsSelected.isNotEmpty &&
                                          currentPointsSelected != "Points") {
                                        if (gameX01.checkoutPossible()) {
                                          if (gameX01.finishedWithThreeDarts(
                                              currentPointsSelected)) {
                                            gameX01.submitPoints(
                                                currentPointsSelected);
                                          } else {
                                            if (gameX01.getGameSettings
                                                .getEnableCheckoutCounting) {
                                              int count = gameX01
                                                  .getAmountOfCheckoutPossibilities(
                                                      currentPointsSelected);
                                              if (count != -1) {
                                                showDialogForCheckout(
                                                    gameX01,
                                                    count,
                                                    currentPointsSelected);
                                              } else {
                                                gameX01.submitPoints(
                                                    currentPointsSelected);
                                              }
                                            } else if (gameX01
                                                .finishedLegSetOrGame(
                                                    currentPointsSelected)) {
                                              showDialogForCheckout(gameX01, -1,
                                                  currentPointsSelected);
                                            } else {
                                              gameX01.submitPoints(
                                                  currentPointsSelected);
                                            }
                                          }
                                        } else {
                                          gameX01.submitPoints(
                                              currentPointsSelected);
                                        }
                                      }
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
          PointsBtnsWidget(
            showDialogCallBack: showDialogForCheckout,
          ),
        ],
      ),
    );
  }
}
