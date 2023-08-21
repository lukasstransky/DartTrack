import 'dart:io';

import 'package:dart_app/constants.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsCardItem extends StatelessWidget {
  const SettingsCardItem({
    Key? key,
    required String this.name,
    Function(BuildContext) this.onItemPressed = _emptyFunction,
    String this.route = '',
    bool this.rateApp = false,
    bool this.helpAndSupport = false,
  }) : super(key: key);

  final String name;
  final Function(BuildContext) onItemPressed;
  final String route;
  final bool rateApp;
  final bool helpAndSupport;

  static void _emptyFunction(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: 4.h,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: Utils.getColor(
              Utils.darken(Theme.of(context).colorScheme.primary, 10),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            elevation: MaterialStateProperty.all(0),
            overlayColor: Utils.getColor(
              Utils.darken(Theme.of(context).colorScheme.primary, 20),
            ),
          ),
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            _onPressed(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(left: 1.w),
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                    color: Colors.white,
                  ),
                ),
              ),
              Icon(
                size: ICON_BUTTON_SIZE.h,
                Icons.arrow_forward_sharp,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onPressed(BuildContext context) {
    if (route != '') {
      Navigator.of(context).pushNamed(route);
    } else if (rateApp) {
      _openAppInStore(context);
    } else if (helpAndSupport) {
      _launchEmail(context);
    } else {
      onItemPressed(context);
    }
  }

  _openAppInStore(BuildContext context) {
    String url = '';
    if (Platform.isAndroid) {
      //TODO adjust
      url = 'https://play.google.com/store/apps/details?id=your_package_name';
    } else if (Platform.isIOS) {
      //TODO adjust
      url = 'https://apps.apple.com/app/apple-store/idyour_app_id';
    }

    _launchURL(url, context);
  }

  _launchURL(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Fluttertoast.showToast(
        msg: 'Could not launch $url',
        fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  _launchEmail(BuildContext context) async {
    //TODO adjust
    final String email = 'your_email@example.com';
    final String subject = 'App Help & Support';
    final String body = 'Hello, I need help with...';
    final String url =
        'mailto:$email?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(body)}';

    _launchURL(url, context);
  }
}
