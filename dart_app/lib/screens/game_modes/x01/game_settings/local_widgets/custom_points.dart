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

  void _initTextController(GameSettingsX01 gameSettingsX01) {
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
            title: const Text('Enter Points'),
            content: TextFormField(
              controller: _customPointsController,
              validator: (value) {
                if (value!.isEmpty) {
                  return ('Please Enter Points!');
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

  void _submitPoints(BuildContext context) {
    if (!_formKeyCustomPoints.currentState!.validate()) {
      return;
    }
    _formKeyCustomPoints.currentState!.save();

    Navigator.of(context).pop(int.parse(_customPointsController!.text));
    _customPointsController!.clear();
  }

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    return Expanded(
      child: Selector<GameSettingsX01, int>(
        selector: (_, gameSettingsX01) => gameSettingsX01.getCustomPoints,
        builder: (_, customPoints, __) => Container(
          height: WIDGET_HEIGHT_GAMESETTINGS.h,
          child: ElevatedButton(
            onPressed: () async {
              _initTextController(gameSettingsX01);
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
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(BUTTON_BORDER_RADIUS),
                    bottomRight: Radius.circular(BUTTON_BORDER_RADIUS),
                  ),
                ),
              ),
              backgroundColor: customPoints != -1
                  ? Utils.getColor(Theme.of(context).colorScheme.primary)
                  : Utils.getColor(Colors.grey),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                customPoints == -1 ? 'Custom' : customPoints.toString(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
