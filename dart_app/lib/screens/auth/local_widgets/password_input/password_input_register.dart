import 'package:dart_app/constants.dart';
import 'package:dart_app/models/auth_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PasswordInputRegister extends StatefulWidget {
  const PasswordInputRegister({Key? key}) : super(key: key);

  @override
  State<PasswordInputRegister> createState() => _PasswordInputRegisterState();
}

class _PasswordInputRegisterState extends State<PasswordInputRegister> {
  late TextEditingController passwordRegisterTextController;

  @override
  void initState() {
    super.initState();
    passwordRegisterTextController = new TextEditingController();
  }

  @override
  void dispose() {
    passwordRegisterTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Auth_P auth_p = context.read<Auth_P>();

    passwordRegisterTextController.addListener(() {
      auth_p.setRegisterPassword = passwordRegisterTextController.text;
    });

    return Container(
      padding: EdgeInsets.only(top: 1.h),
      width: 80.w,
      child: Selector<Auth_P, bool>(
        selector: (_, auth) => auth.getPasswordVisible,
        builder: (_, passwordVisible, __) => TextFormField(
          obscureText: !passwordVisible,
          controller: passwordRegisterTextController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            LengthLimitingTextInputFormatter(MAX_PASSWORD_LENGTH),
          ],
          validator: (value) {
            if (value!.trim().isEmpty) {
              passwordRegisterTextController.clear();
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
            hintText: 'Password',
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
