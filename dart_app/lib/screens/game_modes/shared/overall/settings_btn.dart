import 'package:dart_app/constants.dart';
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
          backgroundColor: condition
              ? Utils.getPrimaryMaterialStateColorDarken(context)
              : Utils.getColor(Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
