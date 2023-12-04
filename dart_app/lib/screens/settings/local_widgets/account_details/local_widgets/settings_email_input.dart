import 'package:dart_app/constants.dart';
import 'package:dart_app/models/settings_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class EmailInputField extends StatefulWidget {
  EmailInputField({Key? key}) : super(key: key);

  @override
  State<EmailInputField> createState() => _EmailInputFieldState();
}

class _EmailInputFieldState extends State<EmailInputField> {
  late TextEditingController settingsEmailTextController;

  @override
  void initState() {
    super.initState();
    settingsEmailTextController = new TextEditingController();
  }

  @override
  void dispose() {
    settingsEmailTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    settingsEmailTextController.addListener(() {
      context.read<Settings_P>().setEmail = settingsEmailTextController.text;
    });

    return TextFormField(
      controller: settingsEmailTextController,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return ('Please enter a email!');
        }
        if (!RegExp(EMAIL_REGEX).hasMatch(value)) {
          return ('Please enter a valid email!');
        }
        if (!context.read<Settings_P>().getEmailValid) {
          return 'Email already exists!';
        }

        return null;
      },
      keyboardType: TextInputType.text,
      inputFormatters: [LengthLimitingTextInputFormatter(MAX_EMAIL_LENGTH)],
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
        hintText: 'New email',
        fillColor: Utils.darken(Theme.of(context).colorScheme.primary, 10),
        filled: true,
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
    );
  }
}
