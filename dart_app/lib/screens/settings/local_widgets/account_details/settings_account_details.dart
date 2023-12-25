import 'package:dart_app/constants.dart';
import 'package:dart_app/models/auth_p.dart';
import 'package:dart_app/models/settings_p.dart';
import 'package:dart_app/screens/settings/local_widgets/account_details/local_widgets/settings_confirm_password_input.dart';
import 'package:dart_app/screens/settings/local_widgets/account_details/local_widgets/settings_email_input.dart';
import 'package:dart_app/screens/settings/local_widgets/account_details/local_widgets/settings_email_password_input.dart';
import 'package:dart_app/screens/settings/local_widgets/account_details/local_widgets/settings_new_password_input.dart';
import 'package:dart_app/screens/settings/local_widgets/account_details/local_widgets/settings_old_password_input.dart';
import 'package:dart_app/screens/settings/local_widgets/settings_card_item.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/button_styles.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SettingsAccountDetails extends StatefulWidget {
  const SettingsAccountDetails({Key? key}) : super(key: key);

  @override
  State<SettingsAccountDetails> createState() => _SettingsAccountDetailsState();
}

class _SettingsAccountDetailsState extends State<SettingsAccountDetails> {
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 1.h),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CARD_SHAPE_ROUNDING),
        ),
        elevation: 5,
        margin: EdgeInsets.all(0),
        color: Utils.darken(Theme.of(context).colorScheme.primary, 10),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                left: 1.5.w,
                top: 0.5.h,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                'Account details',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                  color: Utils.getTextColorDarken(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SettingsCardItem(
              name: 'Email',
              onItemPressed: _showDialogForChangingEmail,
            ),
            SettingsCardItem(
              name: 'Password',
              onItemPressed: _showDialogForChangingPassword,
            ),
          ],
        ),
      ),
    );
  }

  _showDialogForChangingEmail(BuildContext context) async {
    final Auth_P auth = context.read<Auth_P>();

    Utils.forcePortraitMode(context);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding:
            Utils.isMobile(context) ? DIALOG_CONTENT_PADDING_MOBILE : null,
        title: Text(
          'Change email',
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
          ),
        ),
        content: Container(
          width: DIALOG_NORMAL_WIDTH.w,
          child: Form(
            key: _emailFormKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: 80.w,
                    child: Selector<Auth_P, bool>(
                      selector: (_, auth) => auth.getPasswordVisible,
                      builder: (_, passwordVisible, __) =>
                          EmailPasswordInputField(),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 1.h),
                    child: EmailInputField(),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Utils.handleVibrationFeedback(context);

              auth.setPasswordVisible = false;
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
            style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              context.read<Settings_P>().setErrorMsg = '';
              Utils.handleVibrationFeedback(context);
              final bool isConnected = await Utils.hasInternetConnection();
              if (!isConnected) {
                return;
              }
              _onSaveClickedForEmailDialog(context);
            },
            child: Text(
              'Update',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
            style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  _onSaveClickedForEmailDialog(BuildContext context) async {
    final AuthService authService = context.read<AuthService>();
    final String newEmail = context.read<Settings_P>().getEmail;

    if (!_emailFormKey.currentState!.validate()) {
      return;
    }

    final bool reauthenticationSuccessful = await _reauthenticateUser(
        authService,
        _emailFormKey,
        context.read<Settings_P>().getEmailPassword);
    if (reauthenticationSuccessful) {
      final bool successful = await authService.updateEmail(
          newEmail, context, Theme.of(context).textTheme.bodyMedium!.fontSize!);
      if (successful) {
        await context.read<AuthService>().updateEmailInFirestore(newEmail);

        Fluttertoast.showToast(
          msg: 'Email updated successfully.',
          toastLength: Toast.LENGTH_LONG,
          fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
        );
      }
      context.read<Auth_P>().setPasswordVisible = false;
      Navigator.of(context).pop();
    }
  }

  _showDialogForChangingPassword(BuildContext context) async {
    Utils.forcePortraitMode(context);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding:
            Utils.isMobile(context) ? DIALOG_CONTENT_PADDING_MOBILE : null,
        title: Text(
          'Change password',
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
          ),
        ),
        content: Container(
          width: DIALOG_NORMAL_WIDTH.w,
          child: Form(
            key: _passwordFormKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  OldPasswordInputField(),
                  Container(
                    padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
                    child: NewPasswordInputField(),
                  ),
                  ConfirmPasswordInputField(),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Utils.handleVibrationFeedback(context);
              context.read<Auth_P>().setPasswordVisible = false;
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
            style: ButtonStyle(
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              context.read<Settings_P>().setErrorMsg = '';
              Utils.handleVibrationFeedback(context);
              final bool isConnected = await Utils.hasInternetConnection();
              if (!isConnected) {
                return;
              }
              _onSaveClickedForPasswordDialog(context);
            },
            child: Text(
              'Update',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
            style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  _onSaveClickedForPasswordDialog(BuildContext context) async {
    if (!_passwordFormKey.currentState!.validate()) {
      return;
    }

    final AuthService authService = context.read<AuthService>();

    final bool reauthenticationSuccessful = await _reauthenticateUser(
        authService,
        _passwordFormKey,
        context.read<Settings_P>().getOldPassword);
    if (reauthenticationSuccessful) {
      String message = 'Password updated successfully.';
      bool closeDialog = true;
      try {
        await authService.getCurrentUser!
            .updatePassword(context.read<Settings_P>().getNewPassword);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          message = 'Error, please logout/login again!';
        } else if (e.code == 'weak-password') {
          message = 'Error, too weak password!';
        }
        closeDialog = false;
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'An unexpected error occurred. Please try again later.',
          toastLength: Toast.LENGTH_LONG,
          fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
        );
        closeDialog = false;
      }

      context.read<Auth_P>().setPasswordVisible = false;
      FocusManager.instance.primaryFocus?.unfocus();
      if (closeDialog) {
        Navigator.of(context).pop();
      }

      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
      );
    }
  }

  Future<bool> _reauthenticateUser(AuthService authService,
      GlobalKey<FormState> formKey, String password) async {
    final AuthCredential credential = EmailAuthProvider.credential(
        email: authService.getCurrentUserEmail!, password: password);

    try {
      await authService.getCurrentUser!
          .reauthenticateWithCredential(credential);

      return true;
    } on FirebaseAuthException catch (e) {
      String _errorMsg = '';
      if (e.code == 'requires-recent-login') {
        _errorMsg = 'Please logout/login again!';
      } else if (e.code == 'wrong-password') {
        _errorMsg = 'Incorrect password!';
      }
      context.read<Settings_P>().setErrorMsg = _errorMsg;

      formKey.currentState!.validate();
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'An unexpected error occurred. Please try again later.',
        toastLength: Toast.LENGTH_LONG,
        fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
      );
    }

    return false;
  }
}
