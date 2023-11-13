import 'package:dart_app/constants.dart';
import 'package:dart_app/models/settings_p.dart';
import 'package:dart_app/screens/game_modes/game_modes_overview.dart';
import 'package:dart_app/screens/settings/settings.dart';
import 'package:dart_app/screens/statistics/statistics.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';

  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List _pages = [
    GameModesOverView(),
    Statistics(),
    SettingsPage(),
  ];

  @override
  void initState() {
    _getAppVersion();
    _initVibrationFeedbackValue();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final AuthService authService = context.read<AuthService>();

    authService.getAdsEnabledFlag(context);
    // lead to some errors in the submit method (login_register_btn.dart)
    if (arguments.isNotEmpty) {
      final String email = arguments['email'];

      if (arguments['isLogin']) {
        authService.storeUsernameInSharedPreferences(email);
      } else if (!arguments['isLogin']) {
        authService.postUserToFirestore(email, arguments['username']);
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Selector<Settings_P, bool>(
        selector: (_, settings) => settings.getShowLoadingSpinner,
        builder: (_, showLoadingSpinner, __) => Scaffold(
          body: _pages[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            elevation: 0,
            onTap: _onTabTapped,
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  IcoFontIcons.dart,
                  size: ICON_BUTTON_SIZE.h,
                ),
                label: 'Play',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.chartBar,
                  size: ICON_BUTTON_SIZE.h,
                ),
                label: 'Statistics',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                  size: ICON_BUTTON_SIZE.h,
                ),
                label: 'Settings',
              ),
            ],
            unselectedFontSize: 10.sp,
            selectedFontSize: 15.sp,
            selectedIconTheme: IconThemeData(
                color: Theme.of(context).colorScheme.secondary, size: 35),
            selectedItemColor: Theme.of(context).colorScheme.secondary,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  _initVibrationFeedbackValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Settings_P settings_p = context.read<Settings_P>();
    final AuthService authService = context.read<AuthService>();

    final bool vibrationFeedbackEnabled = prefs.getBool(
            '${authService.getCurrentUserUid}_$VIBRATION_FEEDBACK_KEY') ??
        false;
    settings_p.setVibrationFeedbackEnabled = vibrationFeedbackEnabled;
  }

  _getAppVersion() async {
    final PackageInfo _packageInfo = await PackageInfo.fromPlatform();
    context.read<Settings_P>().setVersion = _packageInfo.version;
  }

  _onTabTapped(int index) {
    Utils.handleVibrationFeedback(context);
    setState(() {
      _currentIndex = index;
    });
  }
}
