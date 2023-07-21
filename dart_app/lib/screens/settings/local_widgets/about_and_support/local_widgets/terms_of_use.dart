import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:flutter/material.dart';

class TermsOfUse extends StatelessWidget {
  static const routeName = '/termsOfUse';

  const TermsOfUse({Key? key}) : super(key: key);

  //TODO add
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Terms of use',
        showBackBtn: true,
      ),
      body: Container(),
    );
  }
}
