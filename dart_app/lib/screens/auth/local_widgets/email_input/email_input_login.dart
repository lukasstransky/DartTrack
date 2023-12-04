import 'package:dart_app/constants.dart';
import 'package:dart_app/models/auth_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class EmailInputLogin extends StatefulWidget {
  const EmailInputLogin({
    Key? key,
  }) : super(key: key);

  @override
  State<EmailInputLogin> createState() => _EmailInputLoginState();
}

class _EmailInputLoginState extends State<EmailInputLogin> {
  late TextEditingController emailLoginTextController;

  @override
  void initState() {
    super.initState();
    emailLoginTextController = new TextEditingController();
  }

  @override
  void dispose() {
    emailLoginTextController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    emailLoginTextController.clear();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Auth_P auth_p = context.read<Auth_P>();

    emailLoginTextController.addListener(() {
      auth_p.setLoginEmail = emailLoginTextController.text;
    });

    return Container(
      width: 80.w,
      child: TextFormField(
        controller: emailLoginTextController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        inputFormatters: [
          LengthLimitingTextInputFormatter(MAX_EMAIL_LENGTH),
        ],
        validator: (value) {
          if (value!.isEmpty) {
            return ('Email is required!');
          }
          if (!RegExp(EMAIL_REGEX).hasMatch(value)) {
            Utils.setCursorForTextControllerToEnd(emailLoginTextController);
            return ('Please enter a valid email!');
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
            Icons.mail,
            color: Utils.getPrimaryColorDarken(context),
          ),
          hintText: 'Email',
          hintStyle: TextStyle(
            fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
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
