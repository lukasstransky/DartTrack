import 'package:dart_app/models/settings_p.dart';
import 'package:dart_app/screens/settings/local_widgets/logout_btn.dart';
import 'package:dart_app/screens/settings/local_widgets/about_and_support/settings_about_and_support.dart';
import 'package:dart_app/screens/settings/local_widgets/settings_account_data.dart';
import 'package:dart_app/screens/settings/local_widgets/account_details/settings_account_details.dart';
import 'package:dart_app/screens/settings/local_widgets/settings_game_overall.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar_settings_tab.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    // context.read<InAppPurchase_P>().loadProducts(context);
  }

  @override
  Widget build(BuildContext context) {
    final String currentUsername =
        context.read<AuthService>().getUsernameFromSharedPreferences() ?? '';

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: CustomAppBarSettingsTab(),
        body: Selector<Settings_P, bool>(
          selector: (_, settings) => settings.getShowLoadingSpinner,
          builder: (_, showLoadingSpinner, __) => showLoadingSpinner
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Center(
                          child: Container(
                            width: 90.w,
                            child: Column(
                              children: [
                                if (currentUsername != 'Guest') ...[
                                  SettingsAccountDetails(),
                                  SettingsAccountData(),
                                ],
                                SettingsGameOverall(),
                                AboutAndSupport(),
                                LogoutBtn(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
