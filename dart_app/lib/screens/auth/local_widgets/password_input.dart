import 'package:dart_app/constants.dart';
import 'package:dart_app/models/auth.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Auth_P auth = context.read<Auth_P>();

    return Container(
      key: Key('passwordInput'),
      padding: EdgeInsets.only(top: 1.h),
      width: 80.w,
      child: Selector<Auth_P, bool>(
        selector: (_, auth) => auth.getPasswordVisible,
        builder: (_, passwordVisible, __) => TextFormField(
          obscureText: !passwordVisible,
          controller: passwordTextController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            LengthLimitingTextInputFormatter(MAX_PASSWORD_LENGTH),
          ],
          validator: (value) {
            if (value!.trim().isEmpty) {
              passwordTextController.clear();
              return ('Password is required!');
            }
            return null;
          },
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              size: ICON_BUTTON_SIZE.h,
              Icons.lock,
              color: Utils.getPrimaryColorDarken(context),
            ),
            suffixIcon: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Icon(
                size: ICON_BUTTON_SIZE.h,
                passwordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              color: Utils.getPrimaryColorDarken(context),
              onPressed: () {
                auth.setPasswordVisible = !passwordVisible;
                auth.notify();
              },
            ),
            filled: true,
            fillColor: Utils.darken(Theme.of(context).colorScheme.primary, 10),
            hintText: 'Password',
            hintStyle: TextStyle(
              fontSize: 12.sp,
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
