import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class CustomPoints extends StatefulWidget {
  @override
  State<CustomPoints> createState() => _CustomPointsState();
}

class _CustomPointsState extends State<CustomPoints> {
  TextEditingController? _customPointsController;
  final GlobalKey<FormState> _formKeyCustomPoints = GlobalKey<FormState>();

  @override
  initState() {
    _initTextController();
    super.initState();
  }

  _initTextController() {
    final gameSettingsX01 = context.read<GameSettingsX01_P>();
    _customPointsController = new TextEditingController(
        text: gameSettingsX01.getCustomPoints != -1
            ? gameSettingsX01.getCustomPoints.toString()
            : '');
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
            contentPadding: EdgeInsets.only(
                bottom: DIALOG_CONTENT_PADDING_BOTTOM,
                top: DIALOG_CONTENT_PADDING_TOP,
                left: DIALOG_CONTENT_PADDING_LEFT,
                right: DIALOG_CONTENT_PADDING_RIGHT),
            title: Text(
              'Enter points',
              style: TextStyle(color: Colors.white),
            ),
            content: Container(
              margin: EdgeInsets.only(left: 15.w, right: 15.w),
              child: TextFormField(
                controller: _customPointsController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ('Please enter some points!');
                  }
                  if (int.parse(value) < CUSTOM_POINTS_MIN_NUMBER) {
                    return ('Minimum points are 100!');
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
                  hintText: 'max. 9999',
                  fillColor:
                      Utils.darken(Theme.of(context).colorScheme.primary, 10),
                  filled: true,
                  hintStyle: TextStyle(
                    color: Utils.getPrimaryColorDarken(context),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => {
                  Navigator.of(context).pop(),
                },
                child: Text(
                  'Cancel',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                style: ButtonStyle(
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

    Navigator.of(context).pop(int.parse(_customPointsController!.text));
    _customPointsController!.clear();
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
    return Expanded(
      child: Consumer<GameSettingsX01_P>(
        builder: (_, gameSettingsX01, __) => Container(
          height: Utils.getHeightForWidget(gameSettingsX01).h,
          child: ElevatedButton(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                gameSettingsX01.getCustomPoints == -1
                    ? 'Custom'
                    : gameSettingsX01.getCustomPoints.toString(),
                style: TextStyle(
                  color: Utils.getTextColorForGameSettingsBtn(
                      gameSettingsX01.getCustomPoints != -1, context),
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
                    width: GAME_SETTINGS_BTN_BORDER_WITH,
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(BUTTON_BORDER_RADIUS),
                    bottomRight: Radius.circular(BUTTON_BORDER_RADIUS),
                  ),
                ),
              ),
              backgroundColor: gameSettingsX01.getCustomPoints != -1
                  ? Utils.getPrimaryMaterialStateColorDarken(context)
                  : Utils.getColor(Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
      ),
    );
  }
}
