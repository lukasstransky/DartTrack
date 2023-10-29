import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/button_styles.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class CustomPointsX01 extends StatefulWidget {
  @override
  State<CustomPointsX01> createState() => _CustomPointsX01State();
}

class _CustomPointsX01State extends State<CustomPointsX01> {
  final GlobalKey<FormState> _formKeyCustomPoints = GlobalKey<FormState>();

  @override
  initState() {
    _initTextController();
    super.initState();
  }

  _initTextController() {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();
    final String text = gameSettingsX01.getCustomPoints != -1
        ? gameSettingsX01.getCustomPoints.toString()
        : '';

    newTextControllerForCustomPointsGameSettingsX01(text);
  }

  Future<int?> _showDialogForCustomPoints(
          BuildContext context, GameSettingsX01_P gameSettingsX01) =>
      showDialog<int>(
        barrierDismissible: false,
        context: context,
        builder: (context) => Form(
          key: _formKeyCustomPoints,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            contentPadding:
                Utils.isMobile(context) ? DIALOG_CONTENT_PADDING_MOBILE : null,
            title: Text(
              'Enter points',
              style: TextStyle(
                color: Colors.white,
                fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
              ),
            ),
            content: Container(
              width: DIALOG_SMALL_WIDTH.w,
              margin: EdgeInsets.only(
                left: 5.w,
                right: 5.w,
              ),
              child: TextFormField(
                textAlign: TextAlign.center,
                controller: customPointsController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ('Please enter a value!');
                  }
                  if (int.parse(value) < CUSTOM_POINTS_MIN_NUMBER) {
                    return ('Minimum points: ${CUSTOM_POINTS_MIN_NUMBER}');
                  }
                  return null;
                },
                autofocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(MAX_NUMBERS_POINTS),
                ],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                ),
                decoration: InputDecoration(
                  errorStyle: TextStyle(fontSize: DIALOG_ERROR_MSG_FONTSIZE.sp),
                  hintText: 'min. ${CUSTOM_POINTS_MIN_NUMBER}',
                  fillColor:
                      Utils.darken(Theme.of(context).colorScheme.primary, 10),
                  filled: true,
                  hintStyle: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                    color: Utils.getPrimaryColorDarken(context),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Utils.handleVibrationFeedback(context);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  ),
                ),
                style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Utils.handleVibrationFeedback(context);
                  _submitPoints(context);
                },
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  ),
                ),
                style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  _submitPoints(BuildContext context) {
    if (!_formKeyCustomPoints.currentState!.validate()) {
      return;
    }
    _formKeyCustomPoints.currentState!.save();

    Navigator.of(context).pop(int.parse(customPointsController.text));
    customPointsController.clear();
  }

  _customPointsBtnPressed(GameSettingsX01_P gameSettingsX01) async {
    _initTextController();
    final int? result =
        await _showDialogForCustomPoints(context, gameSettingsX01);

    if (result == null) {
      return;
    }

    switch (result) {
      case 301:
        gameSettingsX01.setPoints = 301;
        gameSettingsX01.setCustomPoints = -1;
        break;
      case 501:
        gameSettingsX01.setPoints = 501;
        gameSettingsX01.setCustomPoints = -1;
        break;
      case 701:
        gameSettingsX01.setPoints = 701;
        gameSettingsX01.setCustomPoints = -1;
        break;
      default:
        gameSettingsX01.setCustomPoints = result;
        break;
    }
    gameSettingsX01.notify();
  }

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();
    final shape = MaterialStateProperty.all(
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
    );

    return Expanded(
      child: Selector<GameSettingsX01_P, SelectorModel>(
        selector: (_, gameSettingsX01) => SelectorModel(
          customPoints: gameSettingsX01.getCustomPoints,
          singleOrTeam: gameSettingsX01.getSingleOrTeam,
        ),
        builder: (_, selectorModel, __) => Container(
          height: WIDGET_HEIGHT_GAMESETTINGS.h,
          child: ElevatedButton(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                selectorModel.customPoints == -1
                    ? 'Custom'
                    : selectorModel.customPoints.toString(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Utils.getTextColorForGameSettingsBtn(
                          selectorModel.customPoints != -1, context),
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium!.fontSize,
                    ),
              ),
            ),
            onPressed: () {
              Utils.handleVibrationFeedback(context);
              _customPointsBtnPressed(gameSettingsX01);
            },
            style: selectorModel.customPoints == -1
                ? ButtonStyles.primaryColorBtnStyle(
                        context, selectorModel.customPoints != -1)
                    .copyWith(shape: shape)
                : ButtonStyles.darkPrimaryColorBtnStyle(context)
                    .copyWith(shape: shape),
          ),
        ),
      ),
    );
  }
}

class SelectorModel {
  final int customPoints;
  final SingleOrTeamEnum singleOrTeam;

  SelectorModel({
    required this.customPoints,
    required this.singleOrTeam,
  });
}
