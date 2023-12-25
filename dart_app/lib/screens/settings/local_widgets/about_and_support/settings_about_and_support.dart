import 'package:dart_app/constants.dart';
import 'package:dart_app/models/in_app_purchase_p.dart';
import 'package:dart_app/models/user_p.dart';
import 'package:dart_app/screens/settings/local_widgets/about_and_support/local_widgets/app.version.dart';
import 'package:dart_app/screens/settings/local_widgets/settings_card_item.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AboutAndSupport extends StatelessWidget {
  const AboutAndSupport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String currentUsername =
        context.read<AuthService>().getUsernameFromSharedPreferences() ?? '';

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
            // if (currentUsername != 'Guest' && context.read<User_P>().adsEnabled)
            //   Consumer<InAppPurchase_P>(
            //     builder: (context, inAppPurchaseProvider, child) {
            //       if (inAppPurchaseProvider.purchaseSuccessful) {
            //         WidgetsBinding.instance.addPostFrameCallback((_) {
            //           _onPurchaseSuccess(context);
            //         });
            //       }
            //       return SettingsCardItem(
            //         name: 'Remove ads 2,99€',
            //         buyAdFreeVersion: true,
            //       );
            //     },
            //   ),
            SettingsCardItem(
              name: 'Help & Support',
              helpAndSupport: true,
            ),
            // SettingsCardItem(
            //   name: 'Rate app',
            //   rateApp: true,
            // ),
            SettingsCardItem(
              name: 'Privacy policy',
              privacyPolicy: true,
            ),
            SettingsCardItem(
              name: 'Terms of use',
              termsOfUse: true,
            ),
            AppVersion(),
          ],
        ),
      ),
    );
  }

  void _onPurchaseSuccess(BuildContext context) {
    print('_onPurchaseSuccess');
    context.read<AuthService>().setAdsEnabledFlagToFalse(context);
    context.read<InAppPurchase_P>().resetPurchaseSuccessfulFlag();
  }
}
