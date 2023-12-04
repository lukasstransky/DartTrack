import 'package:dart_app/constants.dart';
import 'package:dart_app/models/auth_p.dart';
import 'package:dart_app/models/settings_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ConfirmPasswordInputField extends StatefulWidget {
  const ConfirmPasswordInputField({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfirmPasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<ConfirmPasswordInputField> {
  late TextEditingController settingsConfirmationPasswordController;

  @override
  void initState() {
    settingsConfirmationPasswordController = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    settingsConfirmationPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Auth_P auth = context.read<Auth_P>();
    final Settings_P settings = context.read<Settings_P>();

    settingsConfirmationPasswordController.addListener(() {
      settings.setConfirmPassword = settingsConfirmationPasswordController.text;
    });

    return Container(
      width: 80.w,
      child: Selector<Auth_P, bool>(
        selector: (_, auth) => auth.getPasswordVisible,
        builder: (_, passwordVisible, __) => TextFormField(
          obscureText: !passwordVisible,
          controller: settingsConfirmationPasswordController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            LengthLimitingTextInputFormatter(MAX_PASSWORD_LENGTH),
          ],
          validator: (value) {
            if (value!.trim().isEmpty) {
              settingsConfirmationPasswordController.clear();
              return ('Password is required!');
            }
            if (value != context.read<Settings_P>().getNewPassword) {
              return 'The passwords do not match!';
            }
            return null;
          },
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
          ),
          decoration: InputDecoration(
            errorStyle: TextStyle(fontSize: DIALOG_ERROR_MSG_FONTSIZE.sp),
            prefixIcon: Icon(
              size: ICON_BUTTON_SIZE.h,
              Icons.lock,
              color: Utils.getPrimaryColorDarken(context),
            ),
            suffixIcon: IconButton(
              splashColor:
                  Utils.darken(Theme.of(context).colorScheme.primary, 10),
              splashRadius: SPLASH_RADIUS,
              highlightColor:
                  Utils.darken(Theme.of(context).colorScheme.primary, 10),
              icon: Icon(
                  size: ICON_BUTTON_SIZE.h,
                  passwordVisible ? Icons.visibility : Icons.visibility_off),
              color: Utils.getPrimaryColorDarken(context),
              onPressed: () {
                Utils.handleVibrationFeedback(context);
                auth.setPasswordVisible = !passwordVisible;
                auth.notify();
              },
            ),
            filled: true,
            fillColor: Utils.darken(Theme.of(context).colorScheme.primary, 10),
            hintText: 'Confirm password',
            hintStyle: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              color: Utils.getPrimaryColorDarken(context),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
