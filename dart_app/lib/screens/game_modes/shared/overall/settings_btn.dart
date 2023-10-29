import 'package:dart_app/constants.dart';
import 'package:dart_app/utils/button_styles.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SettingsBtn extends StatelessWidget {
  const SettingsBtn({
    Key? key,
    required this.condition,
    required this.text,
    required this.isLeftBtn,
    required this.onPressed,
  }) : super(key: key);

  final bool condition;
  final String text;
  final bool isLeftBtn;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 4.h,
        child: ElevatedButton(
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            onPressed();
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              style: TextStyle(
                color: Utils.getTextColorForGameSettingsBtn(condition, context),
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
          ),
          style: ButtonStyles.primaryColorBtnStyle(context, condition).copyWith(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                side: BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: GAME_SETTINGS_BTN_BORDER_WITH.w,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: isLeftBtn
                      ? Radius.circular(BUTTON_BORDER_RADIUS)
                      : Radius.zero,
                  bottomLeft: isLeftBtn
                      ? Radius.circular(BUTTON_BORDER_RADIUS)
                      : Radius.zero,
                  topRight: !isLeftBtn
                      ? Radius.circular(BUTTON_BORDER_RADIUS)
                      : Radius.zero,
                  bottomRight: !isLeftBtn
                      ? Radius.circular(BUTTON_BORDER_RADIUS)
                      : Radius.zero,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
