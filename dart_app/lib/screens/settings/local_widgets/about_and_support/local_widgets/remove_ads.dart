import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RemoveAds extends StatelessWidget {
  static const routeName = '/removeAds';

  const RemoveAds({Key? key}) : super(key: key);

  //TODO add
  @override
  Widget build(BuildContext context) {
    context.read<AuthService>().setAdsEnabledFlagToFalse(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Remove ads',
        showBackBtn: true,
      ),
      body: Container(),
    );
  }
}
