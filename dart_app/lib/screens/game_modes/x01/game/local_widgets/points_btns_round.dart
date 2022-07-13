import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/point_btn_round.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/revert_btn.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/submit_points_btn.dart';
import 'package:dart_app/screens/game_modes/x01/shared.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:developer';

class PointsBtnsRound extends StatelessWidget {
  PointsBtnsRound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameX01>(
      builder: (_, gameX01, __) => Expanded(
        child: Column(
          children: [
            Container(
              height: 6.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 25.w,
                    padding: const EdgeInsets.all(5),
                    child: RevertBtn(),
                  ),
                  Container(
                    width: 50.w,
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: Center(
                        child: Text(
                          gameX01.getCurrentPointsSelected,
                          style: TextStyle(fontSize: 20.sp),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 25.w,
                    padding: const EdgeInsets.all(5),
                    child: SubmitPointsBtn(),
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
                        right: MARGIN_GAMESETTINGS,
                        bottom: MARGIN_GAMESETTINGS,
                      ),
                      child: gameX01.checkIfPointBtnShouldBeDisabled("1")
                          ? PointBtnRound(point: "1", activeBtn: true)
                          : PointBtnRound(point: "1", activeBtn: false),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        right: MARGIN_GAMESETTINGS,
                        bottom: MARGIN_GAMESETTINGS,
                      ),
                      child: gameX01.checkIfPointBtnShouldBeDisabled("2")
                          ? PointBtnRound(point: "2", activeBtn: true)
                          : PointBtnRound(point: "2", activeBtn: false),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        bottom: MARGIN_GAMESETTINGS,
                      ),
                      child: gameX01.checkIfPointBtnShouldBeDisabled("3")
                          ? PointBtnRound(point: "3", activeBtn: true)
                          : PointBtnRound(point: "3", activeBtn: false),
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
                        right: MARGIN_GAMESETTINGS,
                        bottom: MARGIN_GAMESETTINGS,
                      ),
                      child: gameX01.checkIfPointBtnShouldBeDisabled("4")
                          ? PointBtnRound(point: "4", activeBtn: true)
                          : PointBtnRound(point: "4", activeBtn: false),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        right: MARGIN_GAMESETTINGS,
                        bottom: MARGIN_GAMESETTINGS,
                      ),
                      child: gameX01.checkIfPointBtnShouldBeDisabled("5")
                          ? PointBtnRound(point: "5", activeBtn: true)
                          : PointBtnRound(point: "5", activeBtn: false),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        bottom: MARGIN_GAMESETTINGS,
                      ),
                      child: gameX01.checkIfPointBtnShouldBeDisabled("6")
                          ? PointBtnRound(point: "6", activeBtn: true)
                          : PointBtnRound(point: "6", activeBtn: false),
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
                        right: MARGIN_GAMESETTINGS,
                        bottom: MARGIN_GAMESETTINGS,
                      ),
                      child: gameX01.checkIfPointBtnShouldBeDisabled("7")
                          ? PointBtnRound(point: "7", activeBtn: true)
                          : PointBtnRound(point: "7", activeBtn: false),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        right: MARGIN_GAMESETTINGS,
                        bottom: MARGIN_GAMESETTINGS,
                      ),
                      child: gameX01.checkIfPointBtnShouldBeDisabled("8")
                          ? PointBtnRound(point: "8", activeBtn: true)
                          : PointBtnRound(point: "8", activeBtn: false),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        bottom: MARGIN_GAMESETTINGS,
                      ),
                      child: gameX01.checkIfPointBtnShouldBeDisabled("9")
                          ? PointBtnRound(point: "9", activeBtn: true)
                          : PointBtnRound(point: "9", activeBtn: false),
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
                        right: MARGIN_GAMESETTINGS,
                      ),
                      child: gameX01.checkIfPointBtnShouldBeDisabled("delete")
                          ? ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.primary),
                                overlayColor: Utils.getColorOrPressed(
                                  Theme.of(context).colorScheme.primary,
                                  Utils.darken(
                                      Theme.of(context).colorScheme.primary,
                                      15),
                                ),
                              ),
                              child: Icon(
                                FeatherIcons.delete,
                                size: 30.sp,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                gameX01.deleteCurrentPointsSelected();
                              })
                          : ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                    Utils.darken(
                                        Theme.of(context).colorScheme.primary,
                                        30)),
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              child: Icon(
                                FeatherIcons.delete,
                                size: 30.sp,
                                color: Colors.black,
                              ),
                              onPressed: () {}),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        right: MARGIN_GAMESETTINGS,
                      ),
                      child: gameX01.checkIfPointBtnShouldBeDisabled("0")
                          ? PointBtnRound(point: "0", activeBtn: true)
                          : PointBtnRound(point: "0", activeBtn: false),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.primary),
                            overlayColor: Utils.getColorOrPressed(
                              Theme.of(context).colorScheme.primary,
                              Utils.darken(
                                  Theme.of(context).colorScheme.primary, 15),
                            ),
                          ),
                          child: Text(
                            "Bust",
                            style: TextStyle(
                              fontSize: 25.sp,
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () {
                            if (gameX01.getGameSettings
                                    .getEnableCheckoutCounting &&
                                gameX01.checkoutPossible()) {
                              int count =
                                  gameX01.getAmountOfCheckoutPossibilities("0");
                              if (count != -1) {
                                showDialogForCheckout(
                                    gameX01, count, "0", context);
                              } else {
                                gameX01.bust(context);
                              }
                            } else {
                              gameX01.bust(context);
                            }
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
