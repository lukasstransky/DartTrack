import 'package:dart_app/constants.dart';
import 'package:dart_app/models/settings_p.dart';
import 'package:dart_app/screens/settings/local_widgets/settings_card_item.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
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
              height: 5.h,
              padding: EdgeInsets.only(
                left: 1.5.w,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                'Game',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Utils.getTextColorDarken(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            VibrationFeedbackSwitch(),
            SettingsCardItem(
                name: 'Change theme',
                onItemPressed: _showDialogForChangingTheme),
          ],
        ),
      ),
    );
  }
}

//todo
_showDialogForChangingTheme(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      contentPadding: dialogContentPadding,
      title: Text(
        'Change theme',
        style: TextStyle(
          color: Colors.white,
          fontSize: DIALOG_TITLE_FONTSIZE.sp,
        ),
      ),
      content: Container(
        width: DIALOG_WIDTH.w,
        child: Text(
          "Change theme",
          style: TextStyle(
            fontSize: DIALOG_CONTENT_FONTSIZE.sp,
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
              fontSize: DIALOG_BTN_FONTSIZE.sp,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: Utils.getPrimaryMaterialStateColorDarken(context),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Utils.handleVibrationFeedback(context);
          },
          child: Text(
            'Update',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: DIALOG_BTN_FONTSIZE.sp,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: Utils.getPrimaryMaterialStateColorDarken(context),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class VibrationFeedbackSwitch extends StatefulWidget {
  const VibrationFeedbackSwitch({Key? key}) : super(key: key);

  @override
  State<VibrationFeedbackSwitch> createState() =>
      _VibrationFeedbackSwitchState();
}

class _VibrationFeedbackSwitchState extends State<VibrationFeedbackSwitch> {
  bool _vibrationFeedbackEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSwitchValue();
  }

  _loadSwitchValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Settings_P settings_p = context.read<Settings_P>();
    final AuthService authService = context.read<AuthService>();

    setState(() {
      _vibrationFeedbackEnabled = prefs.getBool(
              '${authService.getCurrentUserUid}_$VIBRATION_FEEDBACK_KEY') ??
          false;
      settings_p.setVibrationFeedbackEnabled = _vibrationFeedbackEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Settings_P settings_p = context.read<Settings_P>();
    final AuthService authService = context.read<AuthService>();

    late double scaleFactorSwitch;
    if (ResponsiveBreakpoints.of(context).isMobile) {
      scaleFactorSwitch = SWTICH_SCALE_FACTOR_MOBILE;
    } else if (ResponsiveBreakpoints.of(context).isTablet ||
        ResponsiveBreakpoints.of(context).isDesktop) {
      scaleFactorSwitch = SWTICH_SCALE_FACTOR_TABLET;
    } else {
      scaleFactorSwitch = SWTICH_SCALE_FACTOR_TABLET;
    }

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
                  padding: EdgeInsets.only(left: 2.5.w),
                  child: Text(
                    'Vibration feedback',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  transform: Matrix4.translationValues(3.w, 0.0, 0.0),
                  child: Transform.scale(
                    scale: scaleFactorSwitch,
                    child: Switch(
                      thumbColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.secondary),
                      activeColor: Theme.of(context).colorScheme.secondary,
                      inactiveThumbColor:
                          Theme.of(context).colorScheme.secondary,
                      value: _vibrationFeedbackEnabled,
                      onChanged: (value) async {
                        Utils.handleVibrationFeedback(context);
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool(
                            '${authService.getCurrentUserUid}_$VIBRATION_FEEDBACK_KEY',
                            value);
                        setState(
                          () {
                            _vibrationFeedbackEnabled = value;
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
