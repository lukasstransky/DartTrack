import 'package:dart_app/models/game_settings/game_settings_x01_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AdvancedSettings extends StatelessWidget {
  const AdvancedSettings({Key? key}) : super(key: key);

  void _showDialogForAdvancedSettings(
      BuildContext context, GameSettingsX01 gameSettingsX01) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hide/Show"),
        content: StatefulBuilder(
          builder: ((context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  value: gameSettingsX01.getShowAverage,
                  onChanged: (value) {
                    setState(() {
                      gameSettingsX01.setShowAverage = value;
                    });
                  },
                  title: const Text("Average"),
                ),
                SwitchListTile(
                  value: gameSettingsX01.getShowFinishWays,
                  onChanged: (value) {
                    setState(() {
                      gameSettingsX01.setShowFinishWays = value;
                    });
                  },
                  title: const Text("Finish Ways"),
                ),
                SwitchListTile(
                  value: gameSettingsX01.getShowLastThrow,
                  onChanged: (value) {
                    setState(() {
                      gameSettingsX01.setShowLastThrow = value;
                    });
                  },
                  title: const Text("Last Throw"),
                ),
                SwitchListTile(
                  value: gameSettingsX01.getShowThrownDartsPerLeg,
                  onChanged: (value) {
                    setState(() {
                      gameSettingsX01.setShowThrownDartsPerLeg = value;
                    });
                  },
                  title: const Text("Thrown Darts per Leg"),
                ),
              ],
            );
          }),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Submit"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    return Padding(
      padding: EdgeInsets.only(left: 7.w),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () {
            _showDialogForAdvancedSettings(context, gameSettingsX01);
          },
          icon: Icon(
            Icons.settings,
          ),
          label: const Text(
            "Advanced Setttings",
          ),
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
