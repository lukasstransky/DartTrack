import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  static const routeName = '/privacyPolicy';

  const PrivacyPolicy({Key? key}) : super(key: key);

  //TODO add
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Privacy policy',
        showBackBtn: true,
      ),
      body: Container(),
    );
  }
}
