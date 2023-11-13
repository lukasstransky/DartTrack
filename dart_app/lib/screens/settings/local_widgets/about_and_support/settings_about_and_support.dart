import 'package:dart_app/constants.dart';
import 'package:dart_app/models/user_p.dart';
import 'package:dart_app/screens/settings/local_widgets/about_and_support/local_widgets/app.version.dart';
import 'package:dart_app/screens/settings/local_widgets/settings_card_item.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AboutAndSupport extends StatelessWidget {
  const AboutAndSupport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 2.0.h,
      ),
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
                'About & Support',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                  color: Utils.getTextColorDarken(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (context.read<User_P>().adsEnabled)
              SettingsCardItem(
                name: 'Remove ads 2,99€',
                route: '/removeAds',
              ),
            SettingsCardItem(
              name: 'Help & Support',
              helpAndSupport: true,
            ),
            SettingsCardItem(
              name: 'Rate app',
              rateApp: true,
            ),
            SettingsCardItem(
              name: 'Privacy policy',
              route: '/privacyPolicy',
            ),
            SettingsCardItem(
              name: 'Terms of use',
              route: '/termsOfUse',
            ),
            AppVersion(),
          ],
        ),
      ),
    );
  }
}
