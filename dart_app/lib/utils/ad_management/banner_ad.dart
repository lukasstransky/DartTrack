import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyBannerAd {
  BannerAd? _bannerAd;
  final String adUnitId;
  DateTime? _lastAdShownTime;
  bool _isAdLoaded = false;

  MyBannerAd({required this.adUnitId});

  void load(Function() onAdLoadedCallback) async {
    final bool isConnected = await Utils.hasInternetConnection();
    if (!isConnected) {
      print('No internet connection!');
      return;
    }

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          _isAdLoaded = true;
          _lastAdShownTime = DateTime.now();
          onAdLoadedCallback(); // to update ui
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Banner ad failed to load: $error');
        },
      ),
    );

    _bannerAd!.load();
  }

  Widget adContainer() {
    if (_bannerAd == null) {
      return SizedBox(height: 50);
    } else {
      return Container(
        alignment: Alignment.center,
        child: AdWidget(ad: _bannerAd!),
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
      );
    }
  }

  void disposeIfStale([bool disposeInstant = false]) {
    final currentTime = DateTime.now();
    if (disposeInstant ||
        _lastAdShownTime == null ||
        currentTime.difference(_lastAdShownTime!).inSeconds > 5) {
      dispose();
    }
  }

  void dispose() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _isAdLoaded = false;
    _lastAdShownTime = null;
  }

  bool get isAdLoaded => this._isAdLoaded;
}
