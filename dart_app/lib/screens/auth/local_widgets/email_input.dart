import 'package:dart_app/models/auth.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class EmailInput extends StatelessWidget {
  final bool isForgotPasswordScreen;
  final bool isRegisterScreen;

  const EmailInput(
      {Key? key,
      this.isForgotPasswordScreen = false,
      this.isRegisterScreen = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Auth_P auth = context.read<Auth_P>();

    return Container(
      width: 80.w,
      child: TextFormField(
        key: Key('emailInput'),
        controller: emailTextController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value!.isEmpty) {
            return ('Email is required!');
          } else if (!RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\\.[a-z]{2,}')
              .hasMatch(value)) {
            emailTextController.clear();
            return ('Please enter a valid email!');
          } else if (isRegisterScreen && auth.getEmailAlreadyExists) {
            emailTextController.clear();
            return 'Email already exists!';
          } else if (isForgotPasswordScreen && !auth.getEmailAlreadyExists) {
            emailTextController.clear();
            return 'Email does not exist!';
          }
          return null;
        },
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.mail,
            color: Utils.getPrimaryColorDarken(context),
          ),
          hintText: 'Email',
          hintStyle: TextStyle(
            color: Utils.getPrimaryColorDarken(context),
          ),
          filled: true,
          fillColor: Utils.darken(Theme.of(context).colorScheme.primary, 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
        ),
      ),
    );
  }
}
