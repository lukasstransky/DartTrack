import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

final TextEditingController _customPointsController =
    new TextEditingController();
final GlobalKey<FormState> _formKeyPoints = GlobalKey<FormState>();

class CustomPointsWidget extends StatelessWidget {
  const CustomPointsWidget({Key? key}) : super(key: key);

  Future<int?> _openDialogForPoints(
          BuildContext context, GameSettingsX01 GameSettingsX01) =>
      showDialog<int>(
        barrierDismissible: false,
        context: context,
        builder: (context) => Form(
          key: _formKeyPoints,
          child: AlertDialog(
            title: const Text("Enter Points"),
            content: TextFormField(
              controller: _customPointsController,
              validator: (value) {
                if (value!.isEmpty) {
                  return ("Please Enter Points!");
                }
                if (int.parse(value) < POINTS_MIN_NUMBER) {
                  return ("Minimum Points are 100!");
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
                hintText: "max 9999",
                filled: true,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => {
                  Navigator.of(context).pop(),
                  GameSettingsX01.setPoints = 501,
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => _submitPoints(context),
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      );

  void _submitPoints(BuildContext context) {
    if (!_formKeyPoints.currentState!.validate()) {
      return;
    }
    _formKeyPoints.currentState!.save();

    Navigator.of(context).pop(int.parse(_customPointsController.text));
    _customPointsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    return Expanded(
      child: Selector<GameSettingsX01, int>(
        selector: (_, gameSettingsX01) => gameSettingsX01.getCustomPoints,
        builder: (_, customPoints, __) => SizedBox(
          height: HEIGHT_GAMESETTINGS_WIDGETS.h,
          child: ElevatedButton(
            onPressed: () async {
              int? result =
                  await _openDialogForPoints(context, gameSettingsX01);
              if (result == null) return;
              if (result == 301) {
                gameSettingsX01.setPoints = 301;
                gameSettingsX01.setCustomPoints = -1;
              } else if (result == 501) {
                gameSettingsX01.setPoints = 501;
                gameSettingsX01.setCustomPoints = -1;
              } else if (result == 701) {
                gameSettingsX01.setPoints = 701;
                gameSettingsX01.setCustomPoints = -1;
              } else {
                gameSettingsX01.setCustomPoints = result;
              }
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
              ),
              backgroundColor: customPoints != -1
                  ? MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary)
                  : MaterialStateProperty.all<Color>(Colors.grey),
            ),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child:
                  Text(customPoints == -1 ? "Custom" : customPoints.toString()),
            ),
          ),
        ),
      ),
    );
  }
}
