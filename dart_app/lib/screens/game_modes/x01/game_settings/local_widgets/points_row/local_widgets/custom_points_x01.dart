import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
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
            backgroundColor: Theme.of(context).colorScheme.primary,
            contentPadding: dialogContentPadding,
            title: Text(
              'Enter points',
              style: TextStyle(color: Colors.white),
            ),
            content: Container(
              margin: EdgeInsets.only(
                left: 5.w,
                right: 5.w,
              ),
              child: TextFormField(
                controller: customPointsController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ('Please enter some points!');
                  }
                  if (int.parse(value) < CUSTOM_POINTS_MIN_NUMBER) {
                    return ('Minimum points are ${CUSTOM_POINTS_MIN_NUMBER}!');
                  }
                  return null;
                },
                autofocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(MAX_NUMBERS_POINTS),
                ],
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'min. ${CUSTOM_POINTS_MIN_NUMBER}',
                  fillColor:
                      Utils.darken(Theme.of(context).colorScheme.primary, 10),
                  filled: true,
                  hintStyle: TextStyle(
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
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                style: ButtonStyle(
                  splashFactory: NoSplash.splashFactory,
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  backgroundColor:
                      Utils.getPrimaryMaterialStateColorDarken(context),
                ),
              ),
              TextButton(
                onPressed: () => _submitPoints(context),
                child: Text(
                  'Submit',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                style: ButtonStyle(
                  splashFactory: NoSplash.splashFactory,
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  backgroundColor:
                      Utils.getPrimaryMaterialStateColorDarken(context),
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

    return Expanded(
      child: Selector<GameSettingsX01_P, SelectorModel>(
        selector: (_, gameSettingsX01) => SelectorModel(
          customPoints: gameSettingsX01.getCustomPoints,
          singleOrTeam: gameSettingsX01.getSingleOrTeam,
        ),
        builder: (_, selectorModel, __) => Container(
          height: Utils.shouldShrinkWidget(context.read<GameSettingsX01_P>())
              ? WIDGET_HEIGHT_GAMESETTINGS_TEAMS.h
              : WIDGET_HEIGHT_GAMESETTINGS.h,
          child: ElevatedButton(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                selectorModel.customPoints == -1
                    ? 'Custom'
                    : selectorModel.customPoints.toString(),
                style: TextStyle(
                  color: Utils.getTextColorForGameSettingsBtn(
                      selectorModel.customPoints != -1, context),
                ),
              ),
            ),
            onPressed: () => _customPointsBtnPressed(gameSettingsX01),
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
                    topRight: Radius.circular(BUTTON_BORDER_RADIUS),
                    bottomRight: Radius.circular(BUTTON_BORDER_RADIUS),
                  ),
                ),
              ),
              backgroundColor: selectorModel.customPoints != -1
                  ? Utils.getPrimaryMaterialStateColorDarken(context)
                  : Utils.getColor(Theme.of(context).colorScheme.primary),
            ),
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
