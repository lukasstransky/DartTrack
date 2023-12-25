import 'package:dart_app/constants.dart';
import 'package:dart_app/models/auth_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PasswordInputRegisterRepeat extends StatefulWidget {
  const PasswordInputRegisterRepeat({Key? key}) : super(key: key);

  @override
  State<PasswordInputRegisterRepeat> createState() =>
      _PasswordInputRegisterRepeatState();
}

class _PasswordInputRegisterRepeatState
    extends State<PasswordInputRegisterRepeat> {
  late TextEditingController passwordRegisterRepeatTextController;

  @override
  void initState() {
    super.initState();
    passwordRegisterRepeatTextController = new TextEditingController();
  }

  @override
  void dispose() {
    passwordRegisterRepeatTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Auth_P auth_p = context.read<Auth_P>();

    return Container(
      padding: EdgeInsets.only(top: 1.h),
      width: 80.w,
      child: Selector<Auth_P, bool>(
        selector: (_, auth) => auth.getPasswordVisible,
        builder: (_, passwordVisible, __) => TextFormField(
          obscureText: !passwordVisible,
          controller: passwordRegisterRepeatTextController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            LengthLimitingTextInputFormatter(MAX_PASSWORD_LENGTH),
          ],
          validator: (value) {
            if (value!.trim().isEmpty) {
              passwordRegisterRepeatTextController.clear();
              return ('Password is required!');
            }
            if (value != auth_p.getRegisterPassword) {
              return ('Passwords don\'t match!');
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
              splashRadius: SPLASH_RADIUS,
              splashColor:
                  Utils.darken(Theme.of(context).colorScheme.primary, 10),
              highlightColor:
                  Utils.darken(Theme.of(context).colorScheme.primary, 10),
              icon: Icon(
                size: ICON_BUTTON_SIZE.h,
                passwordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              color: Utils.getPrimaryColorDarken(context),
              onPressed: () {
                auth_p.setPasswordVisible = !passwordVisible;
                auth_p.notify();
              },
            ),
            filled: true,
            fillColor: Utils.darken(Theme.of(context).colorScheme.primary, 10),
            hintText: 'Repeat password',
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
