import 'package:dart_app/screens/game_modes/game_modes_overview.dart';
import 'package:dart_app/screens/settings/settings.dart';
import 'package:dart_app/screens/statistics/statistics.dart';
import 'package:dart_app/services/auth_service.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
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

  onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
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
