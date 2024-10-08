import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/utils/button_styles.dart';
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
          toastLength: Toast.LENGTH_LONG,
          fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
        );
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
    final double fontSize = Utils.getResponsiveValue(
      context: context,
      mobileValue: 11,
      tabletValue: 9,
    );

    return Column(
      children: [
        Container(
          height: 4.h,
          padding: EdgeInsets.only(
            left: 5.w,
            right: 5.w,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Utils.handleVibrationFeedback(context);
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
                        fontSize:
                            Theme.of(context).textTheme.bodyMedium!.fontSize,
                      ),
                    ),
                  ),
                  style: ButtonStyles.primaryColorBtnStyle(
                          context, isInputMethodRound)
                      .copyWith(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        side: BorderSide(
                          color: Utils.getPrimaryColorDarken(context),
                          width: GAME_SETTINGS_BTN_BORDER_WITH.w,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(BUTTON_BORDER_RADIUS),
                          bottomLeft: Radius.circular(BUTTON_BORDER_RADIUS),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Utils.handleVibrationFeedback(context);
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
                        fontSize:
                            Theme.of(context).textTheme.bodyMedium!.fontSize,
                      ),
                    ),
                  ),
                  style: ButtonStyles.primaryColorBtnStyle(
                          context, !isInputMethodRound)
                      .copyWith(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        side: BorderSide(
                          color: Utils.getPrimaryColorDarken(context),
                          width: GAME_SETTINGS_BTN_BORDER_WITH.w,
                        ),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(BUTTON_BORDER_RADIUS),
                          bottomRight: Radius.circular(BUTTON_BORDER_RADIUS),
                        ),
                      ),
                    ),
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
                        fontSize: fontSize.sp,
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
                        fontSize: fontSize.sp,
                        color: Colors.white70,
                      ),
                      children: <TextSpan>[
                        new TextSpan(
                            text: 'Enter each dart seperately. As a result, '),
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
