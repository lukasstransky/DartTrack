import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01_model.dart';
import 'package:dart_app/models/games/game_x01_model.dart';
import 'package:dart_app/other/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:developer';

class InGameSettingsX01Screen extends StatelessWidget {
  const InGameSettingsX01Screen({Key? key}) : super(key: key);

  static const routeName = "/inGameSettingsX01";

  @override
  Widget build(BuildContext context) {
    final gameX01 = Provider.of<GameX01>(context, listen: false);

    return Scaffold(
      appBar: CustomAppBar(true, "Game Settings"),
      body: Center(
        child: Container(
          width: 95.w,
          child: Consumer<GameSettingsX01>(
            builder: (_, gameSettingsX01, __) => Column(
              children: [
                SizedBox(
                  height: 24.h,
                  child: Padding(
                    padding: EdgeInsets.only(top: 1.5.h),
                    child: Card(
                      elevation: 5,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: 0.5.h, left: 1.5.w, bottom: 1.h),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Hide/Show",
                                style: TextStyle(
                                    fontSize:
                                        FONTSIZE_HEADINGS_IN_GAME_SETTINGS.sp,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(left: 2.5.w),
                              child: SizedBox(
                                height: HEIGHT_IN_GAME_SETTINGS_WIDGETS.h,
                                child: Row(
                                  children: [
                                    Text(
                                      "Average",
                                      style: TextStyle(
                                          fontSize:
                                              FONTSIZE_IN_GAME_SETTINGS.sp),
                                    ),
                                    Spacer(),
                                    Switch(
                                      value: gameSettingsX01.getShowAverage,
                                      onChanged: (value) {
                                        gameSettingsX01.setShowAverage = value;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(left: 2.5.w),
                              child: SizedBox(
                                height: HEIGHT_IN_GAME_SETTINGS_WIDGETS.h,
                                child: Row(
                                  children: [
                                    Text(
                                      "Finish Ways",
                                      style: TextStyle(
                                          fontSize:
                                              FONTSIZE_IN_GAME_SETTINGS.sp),
                                    ),
                                    Spacer(),
                                    Switch(
                                      value: gameSettingsX01.getShowFinishWays,
                                      onChanged: (value) {
                                        gameSettingsX01.setShowFinishWays =
                                            value;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(left: 2.5.w),
                              child: SizedBox(
                                height: HEIGHT_IN_GAME_SETTINGS_WIDGETS.h,
                                child: Row(
                                  children: [
                                    Text(
                                      "Last Throw",
                                      style: TextStyle(
                                          fontSize:
                                              FONTSIZE_IN_GAME_SETTINGS.sp),
                                    ),
                                    Spacer(),
                                    Switch(
                                      value: gameSettingsX01.getShowLastThrow,
                                      onChanged: (value) {
                                        gameSettingsX01.setShowLastThrow =
                                            value;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(left: 2.5.w),
                              child: SizedBox(
                                height: HEIGHT_IN_GAME_SETTINGS_WIDGETS.h,
                                child: Row(
                                  children: [
                                    Text(
                                      "Thrown Darts per Leg",
                                      style: TextStyle(
                                          fontSize:
                                              FONTSIZE_IN_GAME_SETTINGS.sp),
                                    ),
                                    Spacer(),
                                    Switch(
                                      value: gameSettingsX01
                                          .getShowThrownDartsPerLeg,
                                      onChanged: (value) {
                                        gameSettingsX01
                                            .setShowThrownDartsPerLeg = value;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                  child: Padding(
                    padding: EdgeInsets.only(top: 1.0.h),
                    child: Card(
                      elevation: 5,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: 0.5.h, left: 1.5.w, bottom: 1.h),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "General",
                                style: TextStyle(
                                    fontSize:
                                        FONTSIZE_HEADINGS_IN_GAME_SETTINGS.sp,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(left: 2.5.w),
                              child: SizedBox(
                                height: HEIGHT_IN_GAME_SETTINGS_WIDGETS.h,
                                child: Row(
                                  children: [
                                    Text(
                                      "Caller",
                                      style: TextStyle(
                                          fontSize:
                                              FONTSIZE_IN_GAME_SETTINGS.sp),
                                    ),
                                    Spacer(),
                                    Switch(
                                      value: gameSettingsX01.getCallerEnabled,
                                      onChanged: (value) {
                                        gameSettingsX01.setCallerEnabled =
                                            value;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(left: 2.5.w),
                              child: SizedBox(
                                height: HEIGHT_IN_GAME_SETTINGS_WIDGETS.h,
                                child: Row(
                                  children: [
                                    Text(
                                      "Vibration Feedback",
                                      style: TextStyle(
                                          fontSize:
                                              FONTSIZE_IN_GAME_SETTINGS.sp),
                                    ),
                                    Spacer(),
                                    Switch(
                                      value: gameSettingsX01
                                          .getVibrationFeedbackEnabled,
                                      onChanged: (value) {
                                        gameSettingsX01
                                                .setVibrationFeedbackEnabled =
                                            value;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.h,
                  child: Padding(
                    padding: EdgeInsets.only(top: 1.0.h),
                    child: Card(
                      elevation: 5,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 0.5.h, left: 1.5.w),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Input Method",
                                style: TextStyle(
                                    fontSize:
                                        FONTSIZE_HEADINGS_IN_GAME_SETTINGS.sp,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(left: 2.5.w),
                              child: SizedBox(
                                height: HEIGHT_IN_GAME_SETTINGS_WIDGETS.h,
                                child: Row(
                                  children: [
                                    Text(
                                      "Show in Game Screen",
                                      style: TextStyle(
                                          fontSize:
                                              FONTSIZE_IN_GAME_SETTINGS.sp),
                                    ),
                                    Spacer(),
                                    Switch(
                                      value: gameSettingsX01
                                          .getShowInputMethodInGameScreen,
                                      onChanged: (value) {
                                        gameSettingsX01
                                                .setShowInputMethodInGameScreen =
                                            value;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 5.w, right: 5.w, bottom: 1.h),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: HEIGHT_GAMESETTINGS_WIDGETS.h,
                                      child: ElevatedButton(
                                        onPressed: () =>
                                            gameSettingsX01.getInputMethod ==
                                                    InputMethod.ThreeDarts
                                                ? gameSettingsX01
                                                    .switchInputMethod(gameX01)
                                                : null,
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: const Text("Round"),
                                        ),
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                bottomLeft:
                                                    Radius.circular(10.0),
                                              ),
                                            ),
                                          ),
                                          backgroundColor:
                                              gameSettingsX01.getInputMethod ==
                                                      InputMethod.Round
                                                  ? MaterialStateProperty.all(
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primary)
                                                  : MaterialStateProperty.all<
                                                      Color>(Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      height: HEIGHT_GAMESETTINGS_WIDGETS.h,
                                      child: ElevatedButton(
                                        onPressed: () =>
                                            gameSettingsX01.getInputMethod ==
                                                    InputMethod.Round
                                                ? gameSettingsX01
                                                    .switchInputMethod(gameX01)
                                                : null,
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: const Text("3 Darts"),
                                        ),
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10.0),
                                                bottomRight:
                                                    Radius.circular(10.0),
                                              ),
                                            ),
                                          ),
                                          backgroundColor:
                                              gameSettingsX01.getInputMethod ==
                                                      InputMethod.ThreeDarts
                                                  ? MaterialStateProperty.all(
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primary)
                                                  : MaterialStateProperty.all<
                                                      Color>(Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                                padding:
                                    EdgeInsets.only(left: 2.5.w, bottom: 1.h),
                                child: gameSettingsX01.getInputMethod ==
                                        InputMethod.Round
                                    ? RichText(
                                        text: TextSpan(
                                          style: new TextStyle(
                                            fontSize: 11.0.sp,
                                            color: Colors.black,
                                          ),
                                          children: <TextSpan>[
                                            new TextSpan(
                                                text:
                                                    'Enter a complete round. This approach provides '),
                                            new TextSpan(
                                                text: 'less',
                                                style: new TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            new TextSpan(text: ' statistics.'),
                                          ],
                                        ),
                                      )
                                    : RichText(
                                        text: TextSpan(
                                          style: new TextStyle(
                                            fontSize: 11.0.sp,
                                            color: Colors.black,
                                          ),
                                          children: <TextSpan>[
                                            new TextSpan(
                                                text:
                                                    'Enter each Dart seperately. As a result '),
                                            new TextSpan(
                                                text: 'more',
                                                style: new TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            new TextSpan(
                                                text:
                                                    ' statistics are available.'),
                                          ],
                                        ),
                                      )),
                          ),
                          if (gameSettingsX01.getInputMethod ==
                              InputMethod.Round)
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(left: 2.5.w),
                                child: SizedBox(
                                  height: HEIGHT_IN_GAME_SETTINGS_WIDGETS.h,
                                  child: Row(
                                    children: [
                                      Text(
                                        "Most Scored Points",
                                        style: TextStyle(
                                            fontSize:
                                                FONTSIZE_IN_GAME_SETTINGS.sp),
                                      ),
                                      Spacer(),
                                      Switch(
                                        value: gameSettingsX01
                                            .getShowMostScoredPoints,
                                        onChanged: (value) {
                                          gameSettingsX01
                                              .setShowMostScoredPoints = value;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (gameSettingsX01.getInputMethod ==
                              InputMethod.ThreeDarts)
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(left: 2.5.w),
                                child: SizedBox(
                                  height: HEIGHT_IN_GAME_SETTINGS_WIDGETS.h,
                                  child: Row(
                                    children: [
                                      Text(
                                        "Automatically Submit Points",
                                        style: TextStyle(
                                            fontSize:
                                                FONTSIZE_IN_GAME_SETTINGS.sp),
                                      ),
                                      Spacer(),
                                      Switch(
                                        value: gameSettingsX01
                                            .getAutomaticallySubmitPoints,
                                        onChanged: (value) {
                                          gameSettingsX01
                                                  .setAutomaticallySubmitPoints =
                                              value;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (gameSettingsX01.getEnableCheckoutCounting &&
                    gameSettingsX01.getCheckoutCountingFinallyDisabled ==
                        false &&
                    gameX01.getInit)
                  SizedBox(
                    height: 12.h,
                    child: Padding(
                      padding: EdgeInsets.only(top: 1.0.h),
                      child: Card(
                        elevation: 5,
                        child: Column(
                          children: [
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 0.5.h, left: 1.5.w, bottom: 1.h),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Checkout Counting",
                                    style: TextStyle(
                                        fontSize:
                                            FONTSIZE_HEADINGS_IN_GAME_SETTINGS
                                                .sp,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(left: 2.5.w),
                                child: SizedBox(
                                  height: HEIGHT_IN_GAME_SETTINGS_WIDGETS.h,
                                  child: Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () => gameSettingsX01
                                                .setCheckoutCountingFinallyDisabled =
                                            true,
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: const Text("Disable"),
                                        ),
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                            ),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                        ),
                                      ),
                                      FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          " (can't be re-enabled for this game)",
                                          style: new TextStyle(fontSize: 10.sp),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
