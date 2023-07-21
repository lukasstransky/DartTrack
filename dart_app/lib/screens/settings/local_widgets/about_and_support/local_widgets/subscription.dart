import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:flutter/material.dart';

class Subscription extends StatelessWidget {
  static const routeName = '/subscription';

  const Subscription({Key? key}) : super(key: key);

  //TODO add
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Manage subscription',
        showBackBtn: true,
      ),
      body: Container(),
    );
  }
}
