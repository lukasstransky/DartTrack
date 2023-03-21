import 'package:dart_app/models/auth.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PasswordInput extends StatefulWidget {
  const PasswordInput({Key? key}) : super(key: key);

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  @override
  void initState() {
    super.initState();
    newTextControllerForPassword();
  }

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
          validator: (value) {
            if (value!.isEmpty) {
              return ('Password is required!');
            }
            //todo eventually enable?
            /*if (!RegExp(
                              "^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}\$") //Minimum eight characters, at least one letter and one number
                          .hasMatch(value)) {
                        return ("Please enter a valid password!");
                      }*/
            return null;
          },
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: Utils.getPrimaryColorDarken(context),
            ),
            suffixIcon: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Icon(
                  passwordVisible ? Icons.visibility : Icons.visibility_off),
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
