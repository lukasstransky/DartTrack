import 'package:dart_app/models/settings_p.dart';
import 'package:dart_app/screens/game_modes/game_modes_overview.dart';
import 'package:dart_app/screens/settings/settings.dart';
import 'package:dart_app/screens/statistics/statistics.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
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
    getAppVersion();
    isUsernameUpdated();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final AuthService authService = context.read<AuthService>();

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

  getAppVersion() async {
    final PackageInfo _packageInfo = await PackageInfo.fromPlatform();
    context.read<Settings_P>().setVersion = _packageInfo.version;
  }

  isUsernameUpdated() async {
    final Settings_P settings = context.read<Settings_P>();
    if (settings.getLoadIsUsernameUpdated) {
      final bool _isUsernameUpdated =
          await context.read<AuthService>().isUsernameUpdated();
      settings.setIsUernameUpdated = _isUsernameUpdated;
      settings.setLoadIsUsernameUpdated = false;
    }
  }

  onTabTapped(int index) {
    Utils.handleVibrationFeedback(context);
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(IcoFontIcons.dart),
            label: 'Play',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.chartBar),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedFontSize: 15.sp,
        selectedIconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.secondary, size: 35),
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
