import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
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
    final gameSettingsX01 = context.read<GameSettingsX01>();
    _customPointsController = new TextEditingController(
        text: gameSettingsX01.getCustomPoints != -1
            ? gameSettingsX01.getCustomPoints.toString()
            : '');
  }

  Future<int?> _showDialogForCustomPoints(
          BuildContext context, GameSettingsX01 gameSettingsX01) =>
      showDialog<int>(
        barrierDismissible: false,
        context: context,
        builder: (context) => Form(
          key: _formKeyCustomPoints,
          child: AlertDialog(
            contentPadding: EdgeInsets.only(
                bottom: DIALOG_CONTENT_PADDING_BOTTOM,
                top: DIALOG_CONTENT_PADDING_TOP,
                left: DIALOG_CONTENT_PADDING_LEFT,
                right: DIALOG_CONTENT_PADDING_RIGHT),
            title: const Text('Enter Points'),
            content: TextFormField(
              controller: _customPointsController,
              validator: (value) {
                if (value!.isEmpty) {
                  return ('Please enter Points!');
                }
                if (int.parse(value) < CUSTOM_POINTS_MIN_NUMBER) {
                  return ('Minimum Points are 100!');
                }
                return null;
              },
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(MAX_NUMBERS_POINTS),
              ],
              decoration: InputDecoration(
                hintText: 'max 9999',
                filled: true,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => {
                  Navigator.of(context).pop(),
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => _submitPoints(context),
                child: const Text('Submit'),
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<GameSettingsX01>(
        builder: (_, gameSettingsX01, __) => Container(
          height: Utils.getHeightForWidget(gameSettingsX01).h,
          child: ElevatedButton(
            onPressed: () async {
              _initTextController();
              final int? result =
                  await _showDialogForCustomPoints(context, gameSettingsX01);
              if (result == null) return;
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
            },
            style: ButtonStyle(
              splashFactory: gameSettingsX01.getCustomPoints != -1
                  ? NoSplash.splashFactory
                  : InkRipple.splashFactory,
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: gameSettingsX01.getCustomPoints != -1
                  ? MaterialStateProperty.all(Colors.transparent)
                  : Utils.getDefaultOverlayColor(context),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(BUTTON_BORDER_RADIUS),
                    bottomRight: Radius.circular(BUTTON_BORDER_RADIUS),
                  ),
                ),
              ),
              backgroundColor: gameSettingsX01.getCustomPoints != -1
                  ? Utils.getColor(Theme.of(context).colorScheme.primary)
                  : Utils.getColor(Colors.grey),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                gameSettingsX01.getCustomPoints == -1
                    ? 'Custom'
                    : gameSettingsX01.getCustomPoints.toString(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
