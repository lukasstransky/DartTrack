import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ButtonStyles {
  static ButtonStyle darkPrimaryColorBtnStyle(
    BuildContext context,
  ) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    return ButtonStyle(
      splashFactory: InkRipple.splashFactory,
      shadowColor:
          Utils.getColor(Utils.darken(primaryColor, 50).withOpacity(0.3)),
      overlayColor: Utils.getColor(OVERLAY_COLOR_BTN_DARK),
      backgroundColor: Utils.getColor(
        Utils.darken(primaryColor, GENERAL_DARKEN),
      ),
    );
  }

  static ButtonStyle darkPrimaryColorBtnStyleWithDisabled(
      BuildContext context, bool condition) {
    final splash = condition ? InkRipple.splashFactory : NoSplash.splashFactory;
    final Color shadowColor = condition
        ? Utils.darken(Theme.of(context).colorScheme.primary, 50)
            .withOpacity(0.3)
        : Colors.transparent;
    final Color overlayColor =
        condition ? OVERLAY_COLOR_BTN_DARK : Colors.transparent;
    final MaterialStateProperty<Color> backgroundColor = condition
        ? Utils.getPrimaryMaterialStateColorDarken(context)
        : Utils.getColor(
            Utils.darken(Theme.of(context).colorScheme.primary, 60));

    return ButtonStyle(
      splashFactory: splash,
      shadowColor: Utils.getColor(shadowColor),
      overlayColor: Utils.getColor(overlayColor),
      backgroundColor: backgroundColor,
    );
  }

  // two colors are passed (first -> selected state, second -> not selected state)
  static ButtonStyle twoColorBtnStyle(
      BuildContext context, Color selected, Color notSelected,
      [bool isSelected = false]) {
    final splash =
        isSelected ? NoSplash.splashFactory : InkRipple.splashFactory;
    final Color shadowColor = isSelected
        ? selected.withOpacity(0.3)
        : Utils.darken(notSelected, 30).withOpacity(0.3);
    final Color overlayColor =
        isSelected ? selected : Utils.darken(notSelected, 10);
    final Color backgroundColor = isSelected ? selected : notSelected;

    return ButtonStyle(
      splashFactory: splash,
      shadowColor: Utils.getColor(shadowColor),
      overlayColor: Utils.getColor(overlayColor),
      backgroundColor: Utils.getColor(backgroundColor),
    );
  }

  static ButtonStyle anyColorBtnStyle(BuildContext context, Color color,
      [bool condition = false]) {
    final Color shadowColor = condition
        ? Colors.transparent
        : Utils.darken(color, 30).withOpacity(0.3);
    final Color overlayColor =
        condition ? Colors.transparent : Utils.darken(color, 10);
    final MaterialStateProperty<Color> backgroundColor = condition
        ? Utils.getPrimaryMaterialStateColorDarken(context)
        : Utils.getColor(color);

    return ButtonStyle(
      splashFactory: NoSplash.splashFactory,
      shadowColor: Utils.getColor(shadowColor),
      overlayColor: Utils.getColor(overlayColor),
      backgroundColor: backgroundColor,
    );
  }

  // for game settings buttons like "single or team"
  static ButtonStyle primaryColorBtnStyle(
      BuildContext context, bool condition) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color shadowColor = condition
        ? Colors.transparent
        : Utils.darken(primaryColor, 30).withOpacity(0.3);
    final Color overlayColor =
        condition ? Colors.transparent : Utils.darken(primaryColor, 10);
    final MaterialStateProperty<Color> backgroundColor = condition
        ? Utils.getPrimaryMaterialStateColorDarken(context)
        : Utils.getColor(primaryColor);

    return ButtonStyle(
      splashFactory: NoSplash.splashFactory,
      shadowColor: Utils.getColor(shadowColor),
      overlayColor: Utils.getColor(overlayColor),
      backgroundColor: backgroundColor,
    );
  }
}
