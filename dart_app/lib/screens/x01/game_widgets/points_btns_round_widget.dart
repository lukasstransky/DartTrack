import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_x01_model.dart';
import 'package:dart_app/other/utils.dart';
import 'package:dart_app/screens/x01/game_widgets/point_btn_round_widget.dart';
import 'package:dart_app/screens/x01/game_widgets/revert_btn_widget.dart';
import 'package:dart_app/screens/x01/game_widgets/submit_points_btn_widget.dart';
import 'package:dart_app/screens/x01/game_x01_screen.dart';
import 'package:dart_app/screens/x01/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:developer';

class PointsBtnsRoundWidget extends StatelessWidget {
  PointsBtnsRoundWidget({Key? key}) : super(key: key);

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
                    child: RevertBtnWidget(),
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
                    child: SubmitPointsBtnWidget(),
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
                          ? PointBtnRoundWidget(point: "1", activeBtn: true)
                          : PointBtnRoundWidget(point: "1", activeBtn: false),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        right: MARGIN_GAMESETTINGS,
                        bottom: MARGIN_GAMESETTINGS,
                      ),
                      child: gameX01.checkIfPointBtnShouldBeDisabled("2")
                          ? PointBtnRoundWidget(point: "2", activeBtn: true)
                          : PointBtnRoundWidget(point: "2", activeBtn: false),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        bottom: MARGIN_GAMESETTINGS,
                      ),
                      child: gameX01.checkIfPointBtnShouldBeDisabled("3")
                          ? PointBtnRoundWidget(point: "3", activeBtn: true)
                          : PointBtnRoundWidget(point: "3", activeBtn: false),
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
                          ? PointBtnRoundWidget(point: "4", activeBtn: true)
                          : PointBtnRoundWidget(point: "4", activeBtn: false),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        right: MARGIN_GAMESETTINGS,
                        bottom: MARGIN_GAMESETTINGS,
                      ),
                      child: gameX01.checkIfPointBtnShouldBeDisabled("5")
                          ? PointBtnRoundWidget(point: "5", activeBtn: true)
                          : PointBtnRoundWidget(point: "5", activeBtn: false),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        bottom: MARGIN_GAMESETTINGS,
                      ),
                      child: gameX01.checkIfPointBtnShouldBeDisabled("6")
                          ? PointBtnRoundWidget(point: "6", activeBtn: true)
                          : PointBtnRoundWidget(point: "6", activeBtn: false),
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
                          ? PointBtnRoundWidget(point: "7", activeBtn: true)
                          : PointBtnRoundWidget(point: "7", activeBtn: false),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        right: MARGIN_GAMESETTINGS,
                        bottom: MARGIN_GAMESETTINGS,
                      ),
                      child: gameX01.checkIfPointBtnShouldBeDisabled("8")
                          ? PointBtnRoundWidget(point: "8", activeBtn: true)
                          : PointBtnRoundWidget(point: "8", activeBtn: false),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        bottom: MARGIN_GAMESETTINGS,
                      ),
                      child: gameX01.checkIfPointBtnShouldBeDisabled("9")
                          ? PointBtnRoundWidget(point: "9", activeBtn: true)
                          : PointBtnRoundWidget(point: "9", activeBtn: false),
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
                                overlayColor: Utils.getColor(
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
                          ? PointBtnRoundWidget(point: "0", activeBtn: true)
                          : PointBtnRoundWidget(point: "0", activeBtn: false),
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
                            overlayColor: Utils.getColor(
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
