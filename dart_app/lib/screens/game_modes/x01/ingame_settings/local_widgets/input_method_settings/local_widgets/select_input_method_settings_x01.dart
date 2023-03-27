import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SelectInputMethodSettingsX01 extends StatelessWidget {
  const SelectInputMethodSettingsX01({Key? key}) : super(key: key);

  _switchInputMethod(BuildContext context) {
    final gameX01 = context.read<GameX01_P>();
    final gameSettingsX01 = context.read<GameSettingsX01_P>();

    if (gameSettingsX01.getInputMethod == InputMethod.Round) {
      gameSettingsX01.setInputMethod = InputMethod.ThreeDarts;
    } else {
      if (gameX01.getAmountOfDartsThrown() != 0) {
        Fluttertoast.showToast(
            msg: 'In order to switch, please finish the round!',
            toastLength: Toast.LENGTH_LONG);
      } else {
        gameSettingsX01.setInputMethod = InputMethod.Round;
      }
    }

    gameSettingsX01.notify();
  }

  @override
  Widget build(BuildContext context) {
    final bool isInputMethodRound =
        context.read<GameSettingsX01_P>().getInputMethod == InputMethod.Round
            ? true
            : false;

    return Column(
      children: [
        Container(
          height: 4.h,
          padding: EdgeInsets.only(
            left: 5.w,
            right: 5.w,
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (!isInputMethodRound) {
                      _switchInputMethod(context);
                    }
                  },
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      'Round',
                      style: TextStyle(
                        color: Utils.getTextColorForGameSettingsBtn(
                            isInputMethodRound, context),
                      ),
                    ),
                  ),
                  style: ButtonStyle(
                    splashFactory: NoSplash.splashFactory,
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        side: BorderSide(
                          color: Utils.getPrimaryColorDarken(context),
                          width: GAME_SETTINGS_BTN_BORDER_WITH,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(BUTTON_BORDER_RADIUS),
                          bottomLeft: Radius.circular(BUTTON_BORDER_RADIUS),
                        ),
                      ),
                    ),
                    backgroundColor: isInputMethodRound
                        ? Utils.getPrimaryMaterialStateColorDarken(context)
                        : Utils.getColor(Theme.of(context).colorScheme.primary),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (isInputMethodRound) {
                      _switchInputMethod(context);
                    }
                  },
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      '3 Darts',
                      style: TextStyle(
                        color: Utils.getTextColorForGameSettingsBtn(
                            !isInputMethodRound, context),
                      ),
                    ),
                  ),
                  style: ButtonStyle(
                    splashFactory: NoSplash.splashFactory,
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        side: BorderSide(
                          color: Utils.getPrimaryColorDarken(context),
                          width: GAME_SETTINGS_BTN_BORDER_WITH,
                        ),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(BUTTON_BORDER_RADIUS),
                          bottomRight: Radius.circular(BUTTON_BORDER_RADIUS),
                        ),
                      ),
                    ),
                    backgroundColor: !isInputMethodRound
                        ? Utils.getPrimaryMaterialStateColorDarken(context)
                        : Utils.getColor(Theme.of(context).colorScheme.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 6.h,
          padding: EdgeInsets.only(left: 2.5.w),
          child: isInputMethodRound
              ? Center(
                  child: RichText(
                    text: TextSpan(
                      style: new TextStyle(
                        fontSize: 11.sp,
                        color: Colors.white70,
                      ),
                      children: <TextSpan>[
                        new TextSpan(
                            text:
                                'Enter a complete round. This approach provides '),
                        new TextSpan(
                          text: 'less',
                          style: new TextStyle(fontWeight: FontWeight.bold),
                        ),
                        new TextSpan(text: ' statistics.'),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: RichText(
                    text: TextSpan(
                      style: new TextStyle(
                        fontSize: 11.sp,
                        color: Colors.white70,
                      ),
                      children: <TextSpan>[
                        new TextSpan(
                            text: 'Enter each Dart seperately. As a result '),
                        new TextSpan(
                            text: 'more',
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                        new TextSpan(text: ' statistics are available.'),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
