import 'package:dart_app/constants.dart';
import 'package:dart_app/models/auth.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class UsernameInput extends StatelessWidget {
  const UsernameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Auth_P auth = context.read<Auth_P>();

    return Container(
      width: 80.w,
      padding: EdgeInsets.only(bottom: 1.h),
      child: Theme(
        data: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            errorStyle: TextStyle(
              color: Colors.red, // or any color you want
              fontSize: 20.sp, // adjust this size as needed
            ),
          ),
        ),
        child: TextFormField(
          key: Key('usernameInput'),
          autofocus: false,
          controller: usernameTextController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value!.trim().isEmpty) {
              usernameTextController.clear();
              return ('Username is required!');
            }
            if (!auth.getUsernameValid) {
              return ('Username already exists!');
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
              Icons.person,
              color: Utils.getPrimaryColorDarken(context),
            ),
            hintText: 'Username',
            filled: true,
            fillColor: Utils.darken(Theme.of(context).colorScheme.primary, 10),
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
