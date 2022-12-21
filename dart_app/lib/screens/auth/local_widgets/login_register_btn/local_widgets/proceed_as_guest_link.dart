import 'package:dart_app/models/auth.dart';
import 'package:dart_app/services/auth_service.dart';

import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ProceedAsGuestLink extends StatelessWidget {
  const ProceedAsGuestLink({Key? key}) : super(key: key);

  _clickProceedAsGuest(BuildContext context) async {
    final Auth auth = context.read<Auth>();

    // show loading spinner
    context.loaderOverlay.show();
    auth.notify();

    await context.read<AuthService>().loginAnonymously();
    Navigator.of(context).pushNamed('/home');

    // hide loading spinner
    context.loaderOverlay.hide();
    auth.notify();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0.5.h),
      child: GestureDetector(
        onTap: () async => _clickProceedAsGuest(context),
        child: Text(
          'Proceed as guest',
          style: TextStyle(color: Colors.white38, fontSize: 11.sp),
        ),
      ),
    );
  }
}
