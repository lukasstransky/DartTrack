import 'package:dart_app/constants.dart';
import 'package:dart_app/models/auth_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class UsernameInput extends StatefulWidget {
  const UsernameInput({Key? key}) : super(key: key);

  @override
  State<UsernameInput> createState() => _UsernameInputState();
}

class _UsernameInputState extends State<UsernameInput> {
  late TextEditingController usernameTextController;

  @override
  void initState() {
    super.initState();
    usernameTextController = new TextEditingController();
  }

  @override
  void dispose() {
    usernameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Auth_P auth_p = context.read<Auth_P>();

    usernameTextController.addListener(() {
      auth_p.setUsername = usernameTextController.text;
    });

    return Container(
      width: 80.w,
      padding: EdgeInsets.only(bottom: 1.h),
      child: Theme(
        data: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            errorStyle: TextStyle(
              color: Colors.red,
              fontSize: 20.sp,
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
            if (value == 'Guest' || !auth_p.getUsernameValid) {
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
