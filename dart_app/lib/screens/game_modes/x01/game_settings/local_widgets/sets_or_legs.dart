import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:developer';

class SetsOrLegs extends StatelessWidget {
  const SetsOrLegs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: WIDTH_GAMESETTINGS.w,
        margin: EdgeInsets.only(top: MARGIN_GAMESETTINGS.h),
        child: Consumer<GameSettingsX01>(
          builder: (_, gameSettingsX01, __) => Row(
            children: [
              if (gameSettingsX01.getSetsEnabled)
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 10.w,
                        child: Center(
                          child: Text(
                            "(Sets)",
                            style: TextStyle(fontSize: 8.sp),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () {
                              if (gameSettingsX01.getSets > 1) {
                                if (gameSettingsX01.getMode ==
                                    BestOfOrFirstToEnum.BestOf) {
                                  gameSettingsX01.setSets =
                                      gameSettingsX01.getSets - 2;
                                } else {
                                  gameSettingsX01.setSets =
                                      gameSettingsX01.getSets - 1;
                                }
                              }
                            },
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            icon: Icon(Icons.remove,
                                color: gameSettingsX01.getSets != 1
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey),
                          ),
                          Container(
                            width: 10.w,
                            child: Center(
                              child: Text(
                                gameSettingsX01.getSets.toString(),
                                style: TextStyle(fontSize: 20.sp),
                              ),
                            ),
                          ),
                          IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () {
                              if (gameSettingsX01.getSets < MAX_SETS) {
                                if (gameSettingsX01.getMode ==
                                    BestOfOrFirstToEnum.BestOf) {
                                  gameSettingsX01.setSets =
                                      gameSettingsX01.getSets + 2;
                                } else {
                                  gameSettingsX01.setSets =
                                      gameSettingsX01.getSets + 1;
                                }
                              }
                            },
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            icon: Icon(Icons.add,
                                color: gameSettingsX01.getSets != MAX_SETS
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: SizedBox(
                  height: HEIGHT_GAMESETTINGS_WIDGETS.h,
                  child: ElevatedButton(
                    key: Key("setsBtn"),
                    onPressed: () => gameSettingsX01.setsClicked(),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: const Text("Sets"),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                        ),
                      ),
                      backgroundColor: gameSettingsX01.getSetsEnabled == true
                          ? MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary)
                          : MaterialStateProperty.all<Color>(Colors.grey),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 10.w,
                      child: Center(
                        child: Text(
                          "(Legs)",
                          style: TextStyle(fontSize: 8.sp),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          key: Key("legsRemoveBtn"),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            if (gameSettingsX01.getLegs > 1) {
                              if (gameSettingsX01.getMode ==
                                  BestOfOrFirstToEnum.BestOf) {
                                gameSettingsX01.setLegs =
                                    gameSettingsX01.getLegs - 2;
                              } else {
                                gameSettingsX01.setLegs =
                                    gameSettingsX01.getLegs - 1;
                              }
                            }
                          },
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Icon(Icons.remove,
                              color: gameSettingsX01.getLegs != 1
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey),
                        ),
                        Container(
                          width: 10.w,
                          child: Center(
                            child: Text(
                              gameSettingsX01.getLegs.toString(),
                              style: TextStyle(fontSize: 20.sp),
                            ),
                          ),
                        ),
                        IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            if (gameSettingsX01.getLegs < MAX_LEGS) {
                              if (gameSettingsX01.getMode ==
                                  BestOfOrFirstToEnum.BestOf) {
                                gameSettingsX01.setLegs =
                                    gameSettingsX01.getLegs + 2;
                              } else {
                                gameSettingsX01.setLegs =
                                    gameSettingsX01.getLegs + 1;
                              }
                            }
                          },
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Icon(Icons.add,
                              color: gameSettingsX01.getLegs != MAX_LEGS
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /*Expanded(
                child: NumberPicker(
                  itemHeight: HEIGHT_GAMESETTINGS_WIDGETS.h,
                  value: gameSettingsX01.getSets,
                  itemCount: gameSettingsX01.getSetsEnabled ? 1 : 0,
                  minValue: 1,
                  step:
                      gameSettingsX01.getMode == BestOfOrFirstTo.BestOf ? 2 : 1,
                  maxValue: MAX_SETS,
                  onChanged: (value) {
                    gameSettingsX01.setSets = value;
                  },
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: HEIGHT_GAMESETTINGS_WIDGETS.h,
                  child: ElevatedButton(
                    onPressed: () => gameSettingsX01.setsClicked(),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: const Text("Sets"),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                        ),
                      ),
                      backgroundColor: gameSettingsX01.getSetsEnabled == true
                          ? MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary)
                          : MaterialStateProperty.all<Color>(Colors.grey),
                    ),
                  ),
                ),
              ),
               Expanded(
                child: NumberPicker(
                  itemHeight: HEIGHT_GAMESETTINGS_WIDGETS.h,
                  value: gameSettingsX01.getLegs,
                  itemCount: 1,
                  minValue: 1,
                  step: gameSettingsX01.getMode == BestOfOrFirstTo.BestOf &&
                          gameSettingsX01.getSetsEnabled == false
                      ? 2
                      : 1,
                  maxValue: MAX_LEGS,
                  onChanged: (value) => gameSettingsX01.setLegs = value,
                ),
              ),
              
              Expanded(
                child: SizedBox(
                  height: HEIGHT_GAMESETTINGS_WIDGETS.h,
                  child: ElevatedButton(
                    onPressed: () => gameSettingsX01.legsClicked(),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: const Text("Legs"),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                          ),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
