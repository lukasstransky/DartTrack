import 'package:dart_app/models/auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class UsernameInput extends StatelessWidget {
  const UsernameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Auth auth = context.read<Auth>();

    return Container(
      width: 80.w,
      padding: EdgeInsets.only(bottom: 1.h),
      child: TextFormField(
        key: Key('usernameInput'),
        autofocus: false,
        controller: auth.getUsernameController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value!.isEmpty) {
            return ('Username is required!');
          }
          if (!auth.getUsernameValid) {
            auth.getUsernameController.clear();
            return ('Username already exists!');
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.person,
          ),
          hintText: 'Username',
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
