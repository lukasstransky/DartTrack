import 'package:flutter/material.dart';

class User_P with ChangeNotifier {
  bool adsEnabled = true;

  bool get getAdsEnabled => this.adsEnabled;
  set setAdsEnabled(bool adsEnabled) => this.adsEnabled = adsEnabled;
}
