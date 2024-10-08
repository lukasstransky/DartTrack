import 'package:dart_app/constants.dart';
import 'package:dart_app/models/settings_p.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class SettingsGameOverall extends StatelessWidget {
  const SettingsGameOverall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 2.0.h,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CARD_SHAPE_ROUNDING),
        ),
        elevation: 5,
        margin: EdgeInsets.all(0),
        color: Utils.darken(Theme.of(context).colorScheme.primary, 10),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                left: 1.5.w,
                top: 0.5.h,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                'Game',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                  color: Utils.getTextColorDarken(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            VibrationFeedbackSwitch(),
          ],
        ),
      ),
    );
  }
}

class VibrationFeedbackSwitch extends StatefulWidget {
  const VibrationFeedbackSwitch({Key? key}) : super(key: key);

  @override
  State<VibrationFeedbackSwitch> createState() =>
      _VibrationFeedbackSwitchState();
}

class _VibrationFeedbackSwitchState extends State<VibrationFeedbackSwitch> {
  @override
  Widget build(BuildContext context) {
    final Settings_P settings_p = context.read<Settings_P>();
    final AuthService authService = context.read<AuthService>();
    final double scaleFactorSwitch = Utils.getSwitchScaleFactor(context);
    final double paddingRight = Utils.getResponsiveValue(
      context: context,
      mobileValue: 0.h,
      tabletValue: ADVANCED_SETTINGS_SWITCH_PADDING_RIGHT_TABLET.w,
    );

    return Material(
      color: Colors.transparent,
      child: Container(
        height: 4.h,
        child: Container(
          height: 4.h,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: Utils.getColor(
                Utils.darken(Theme.of(context).colorScheme.primary, 10),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              elevation: MaterialStateProperty.all(0),
              overlayColor: Utils.getColor(Colors.transparent),
            ),
            onPressed: () => null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 1.w),
                  child: Text(
                    'Vibration feedback',
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium!.fontSize,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  transform: Matrix4.translationValues(3.w, 0.0, 0.0),
                  padding: EdgeInsets.only(right: paddingRight),
                  child: Transform.scale(
                    scale: scaleFactorSwitch,
                    child: Switch(
                      thumbColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.secondary),
                      value: settings_p.getVibrationFeedbackEnabled,
                      onChanged: (value) async {
                        Utils.handleVibrationFeedback(context);
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool(
                            '${authService.getCurrentUserUid}_$VIBRATION_FEEDBACK_KEY',
                            value);
                        setState(
                          () {
                            settings_p.setVibrationFeedbackEnabled = value;
                            settings_p.setVibrationFeedbackEnabled = value;
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
