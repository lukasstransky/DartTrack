import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_x01_model.dart';
import 'package:dart_app/other/utils.dart';
import 'package:dart_app/screens/x01/game_widgets/point_btn_widget.dart';
import 'package:dart_app/screens/x01/game_x01_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:developer';

class PointsBtnsWidget extends StatelessWidget {
  PointsBtnsWidget({Key? key, required this.showDialogCallBack})
      : super(key: key);

  final ShowDialogCallBack
      showDialogCallBack; //in order to get the dialog function from the other widget

  @override
  Widget build(BuildContext context) {
    final gameX01 = Provider.of<GameX01>(context, listen: false);

    return Selector<GameX01, String>(
      selector: (_, gameX01) => gameX01.getCurrentPointsSelected,
      builder: (_, currentPointsSelected, __) => Expanded(
        child: Column(
          children: [
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
                          ? PointBtn(point: "1", activeBtn: true)
                          : PointBtn(point: "1", activeBtn: false),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        right: MARGIN_GAMESETTINGS,
                        bottom: MARGIN_GAMESETTINGS,
                      ),
                      child: gameX01.checkIfPointBtnShouldBeDisabled("2")
                          ? PointBtn(point: "2", activeBtn: true)
                          : PointBtn(point: "2", activeBtn: false),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        bottom: MARGIN_GAMESETTINGS,
                      ),
                      child: gameX01.checkIfPointBtnShouldBeDisabled("3")
                          ? PointBtn(point: "3", activeBtn: true)
                          : PointBtn(point: "3", activeBtn: false),
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
                          ? PointBtn(point: "4", activeBtn: true)
                          : PointBtn(point: "4", activeBtn: false),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        right: MARGIN_GAMESETTINGS,
                        bottom: MARGIN_GAMESETTINGS,
                      ),
                      child: gameX01.checkIfPointBtnShouldBeDisabled("5")
                          ? PointBtn(point: "5", activeBtn: true)
                          : PointBtn(point: "5", activeBtn: false),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        bottom: MARGIN_GAMESETTINGS,
                      ),
                      child: gameX01.checkIfPointBtnShouldBeDisabled("6")
                          ? PointBtn(point: "6", activeBtn: true)
                          : PointBtn(point: "6", activeBtn: false),
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
                          ? PointBtn(point: "7", activeBtn: true)
                          : PointBtn(point: "7", activeBtn: false),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        right: MARGIN_GAMESETTINGS,
                        bottom: MARGIN_GAMESETTINGS,
                      ),
                      child: gameX01.checkIfPointBtnShouldBeDisabled("8")
                          ? PointBtn(point: "8", activeBtn: true)
                          : PointBtn(point: "8", activeBtn: false),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        bottom: MARGIN_GAMESETTINGS,
                      ),
                      child: gameX01.checkIfPointBtnShouldBeDisabled("9")
                          ? PointBtn(point: "9", activeBtn: true)
                          : PointBtn(point: "9", activeBtn: false),
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
                          ? PointBtn(point: "0", activeBtn: true)
                          : PointBtn(point: "0", activeBtn: false),
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
                                showDialogCallBack(gameX01, count, "0");
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

typedef ShowDialogCallBack = void Function(
    GameX01 gameX01, int count, String points);
