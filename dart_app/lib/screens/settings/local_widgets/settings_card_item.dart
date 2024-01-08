import 'dart:io';

import 'package:dart_app/constants.dart';
import 'package:dart_app/models/in_app_purchase_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
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
    bool this.buyAdFreeVersion = false,
    bool this.privacyPolicy = false,
    bool this.termsOfUse = false,
  }) : super(key: key);

  final String name;
  final Function(BuildContext) onItemPressed;
  final String route;
  final bool rateApp;
  final bool helpAndSupport;
  final bool buyAdFreeVersion;
  final bool privacyPolicy;
  final bool termsOfUse;

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
          onPressed: () async {
            Utils.handleVibrationFeedback(context);

            if (name != 'Privacy policy' && name != 'Terms of use') {
              final bool isConnected = await Utils.hasInternetConnection();
              if (!isConnected) {
                return;
              }
            }

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
    } else if (buyAdFreeVersion) {
      context.read<InAppPurchase_P>().buyAdFreeVersion();
    } else if (privacyPolicy) {
      _launchURL(
          'https://www.freeprivacypolicy.com/live/aac9d4c5-cdbf-445f-84ee-3c0ba30847b0',
          context);
    } else if (termsOfUse) {
      _launchURL(
          'https://www.app-privacy-policy.com/live.php?token=w2eZKVdamrh7N91z5mWGtQe9ycXDRYFx',
          context);
    } else {
      onItemPressed(context);
    }
  }

  _openAppInStore(BuildContext context) {
    String url = '';
    if (Platform.isAndroid) {
      url =
          'https://play.google.com/store/apps/details?id=com.darttrack&hl=de_AT&gl=US';
    } else if (Platform.isIOS) {
      url = 'https://apps.apple.com/at/app/darttrack/id6474967923';
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
    final String email = 'darttrack.help@gmail.com';
    final String subject = 'Help & Support';
    final String body = 'Hello, I need help with...';
    final String url =
        'mailto:$email?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(body)}';

    _launchURL(url, context);
  }
}
