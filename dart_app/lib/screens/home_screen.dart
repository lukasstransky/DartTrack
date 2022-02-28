import 'package:dart_app/other/custom_app_bar.dart';
import 'package:dart_app/screens/game_modes_overview_screen.dart';

import 'package:dart_app/screens/settings_screen.dart';
import 'package:dart_app/screens/statistics_screen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List _pages = [
    GameModesOverViewScreen(),
    StatisticsScreen(),
    SettingsScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    _createPlayerOfCurrentUser();
    super.initState();
  }

  void _createPlayerOfCurrentUser() async {
    await context.read<AuthService>().createPlayerOfCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("back", "Dart App"),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(IcoFontIcons.dart),
            label: "Play",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.chartBar),
            label: "Statistics",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        selectedFontSize: 20,
        selectedIconTheme: IconThemeData(color: Colors.blue, size: 35),
        selectedItemColor: Colors.blue,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
