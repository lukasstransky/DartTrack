import 'package:dart_app/constants.dart';
import 'package:dart_app/models/auth_p.dart';
import 'package:dart_app/models/settings_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class NewPasswordInputField extends StatefulWidget {
  const NewPasswordInputField({
    Key? key,
  }) : super(key: key);

  @override
  State<NewPasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<NewPasswordInputField> {
  late TextEditingController settingsNewPasswordController;

  @override
  void initState() {
    settingsNewPasswordController = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    settingsNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Auth_P auth = context.read<Auth_P>();
    final Settings_P settings = context.read<Settings_P>();

    settingsNewPasswordController.addListener(() {
      settings.setNewPassword = settingsNewPasswordController.text;
    });

    return Container(
      width: 80.w,
      child: Selector<Auth_P, bool>(
        selector: (_, auth) => auth.getPasswordVisible,
        builder: (_, passwordVisible, __) => TextFormField(
          obscureText: !passwordVisible,
          controller: settingsNewPasswordController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            LengthLimitingTextInputFormatter(MAX_PASSWORD_LENGTH),
          ],
          validator: (value) {
            if (value!.trim().isEmpty) {
              settingsNewPasswordController.clear();
              return ('Password is required!');
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
            hintText: 'New password',
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
