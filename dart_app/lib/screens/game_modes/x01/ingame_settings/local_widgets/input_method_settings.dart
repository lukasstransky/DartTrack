import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class InputMethodSettings extends StatelessWidget {
  const InputMethodSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameX01 = Provider.of<GameX01>(context, listen: false);
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    return SizedBox(
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
                    'Input Method',
                    style: TextStyle(
                        fontSize: FONTSIZE_HEADINGS_IN_GAME_SETTINGS.sp,
                        color: Theme.of(context).colorScheme.primary),
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
                          'Show in Game Screen',
                          style:
                              TextStyle(fontSize: FONTSIZE_IN_GAME_SETTINGS.sp),
                        ),
                        Spacer(),
                        Switch(
                          value: gameSettingsX01.getShowInputMethodInGameScreen,
                          onChanged: (value) {
                            gameSettingsX01.setShowInputMethodInGameScreen =
                                value;
                            gameSettingsX01.notify();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 1.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: WIDGET_HEIGHT_GAMESETTINGS.h,
                          child: ElevatedButton(
                            onPressed: () => gameSettingsX01.getInputMethod ==
                                    InputMethod.ThreeDarts
                                ? gameSettingsX01.switchInputMethod(gameX01)
                                : null,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: const Text('Round'),
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                  ),
                                ),
                              ),
                              backgroundColor: gameSettingsX01.getInputMethod ==
                                      InputMethod.Round
                                  ? MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.primary)
                                  : MaterialStateProperty.all<Color>(
                                      Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: WIDGET_HEIGHT_GAMESETTINGS.h,
                          child: ElevatedButton(
                            onPressed: () => gameSettingsX01.getInputMethod ==
                                    InputMethod.Round
                                ? gameSettingsX01.switchInputMethod(gameX01)
                                : null,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: const Text('3 Darts'),
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                  ),
                                ),
                              ),
                              backgroundColor: gameSettingsX01.getInputMethod ==
                                      InputMethod.ThreeDarts
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
                ),
              ),
              Flexible(
                child: Padding(
                    padding: EdgeInsets.only(left: 2.5.w, bottom: 1.h),
                    child: gameSettingsX01.getInputMethod == InputMethod.Round
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
                                        fontWeight: FontWeight.bold)),
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
                                        fontWeight: FontWeight.bold)),
                                new TextSpan(
                                    text: ' statistics are available.'),
                              ],
                            ),
                          )),
              ),
              if (gameSettingsX01.getInputMethod == InputMethod.Round)
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 2.5.w),
                    child: SizedBox(
                      height: HEIGHT_IN_GAME_SETTINGS_WIDGETS.h,
                      child: Row(
                        children: [
                          Text(
                            'Most Scored Points',
                            style: TextStyle(
                                fontSize: FONTSIZE_IN_GAME_SETTINGS.sp),
                          ),
                          Spacer(),
                          Switch(
                            value: gameSettingsX01.getShowMostScoredPoints,
                            onChanged: (value) {
                              gameSettingsX01.setShowMostScoredPoints = value;
                              gameSettingsX01.notify();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (gameSettingsX01.getInputMethod == InputMethod.ThreeDarts)
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 2.5.w),
                    child: SizedBox(
                      height: HEIGHT_IN_GAME_SETTINGS_WIDGETS.h,
                      child: Row(
                        children: [
                          Text(
                            'Automatically Submit Points',
                            style: TextStyle(
                                fontSize: FONTSIZE_IN_GAME_SETTINGS.sp),
                          ),
                          Spacer(),
                          Switch(
                            value: gameSettingsX01.getAutomaticallySubmitPoints,
                            onChanged: (value) {
                              gameSettingsX01.setAutomaticallySubmitPoints =
                                  value;
                              gameSettingsX01.notify();
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
    );
  }
}
