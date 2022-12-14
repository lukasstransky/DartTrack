import 'package:dart_app/models/auth.dart';

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
    final Auth auth = context.read<Auth>();

    return Container(
      width: 80.w,
      child: TextFormField(
        key: Key('emailInput'),
        controller: context.read<Auth>().getEmailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value!.isEmpty) {
            return ('Email is required!');
          } else if (!RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\\.[a-z]{2,}')
              .hasMatch(value)) {
            auth.getEmailController.clear();
            return ('Please enter a valid email!');
          } else if (isRegisterScreen && auth.getEmailAlreadyExists) {
            auth.getEmailController.clear();
            return 'Email already exists!';
          } else if (isForgotPasswordScreen && !auth.getEmailAlreadyExists) {
            auth.getEmailController.clear();
            return 'Email does not exist!';
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.mail,
          ),
          hintText: 'Email',
          filled: true,
          hintStyle: TextStyle(color: Colors.grey),
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
