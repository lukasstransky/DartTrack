import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdHelper {
  static InterstitialAd? _interstitialAd;

  //TODO replace
  // ios -> ca-app-pub-8582367743573228/7685053941
  // android -> ca-app-pub-8582367743573228/7876625634
  static final String _interstitialAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  static const int maxRetryAttempts = 3;
  static int retryAttemptsInterstitialAd = 0;
  static int retryAttemptsBannerAd = 0;
  static const int retryBaseDelayMillis = 2000;

  static void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          retryAttemptsInterstitialAd = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
          if (retryAttemptsInterstitialAd < maxRetryAttempts) {
            Future.delayed(
                Duration(
                    milliseconds:
                        (retryBaseDelayMillis * retryAttemptsBannerAd)), () {
              retryAttemptsInterstitialAd++;
              loadInterstitialAd();
            });
          }
        },
      ),
    );
  }

  static void showInterstitialAd(Function() onAdDismissedCallback) {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        print('Interstitial ad shown.');
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        onAdDismissedCallback();
        ad.dispose();

        print('Interstitial ad dismissed.');
        loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('Interstitial ad failed to show: $error');
        ad.dispose();
        loadInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  //   static BannerAd? _currentBannerAd;
  // static BannerAd? _preloadedBannerAd;
  // static void preloadBannerAd() async {
  //   final bool isConnected = await Utils.hasInternetConnection();
  //   if (!isConnected) {
  //     return;
  //   }

  //   if (_currentBannerAd == null) {
  //     _currentBannerAd = BannerAd(
  //       adUnitId: _bannerAdUnitId,
  //       size: AdSize.banner,
  //       request: AdRequest(),
  //       listener: BannerAdListener(
  //         onAdLoaded: (Ad ad) {
  //           print('_currentBannerAd loaded.');
  //         },
  //         onAdFailedToLoad: (Ad ad, LoadAdError error) {
  //           print('BannerAd failed to preload: $error');
  //           ad.dispose();
  //           if (retryAttemptsBannerAd < maxRetryAttempts) {
  //             Future.delayed(
  //               Duration(
  //                   milliseconds: retryBaseDelayMillis * retryAttemptsBannerAd),
  //               () {
  //                 retryAttemptsBannerAd++;
  //                 preloadBannerAd();
  //               },
  //             );
  //           }
  //         },
  //       ),
  //     );
  //     _currentBannerAd!.load();
  //   }

  //   if (_preloadedBannerAd == null) {
  //     _preloadedBannerAd = BannerAd(
  //       adUnitId: _bannerAdUnitId,
  //       size: AdSize.banner,
  //       request: AdRequest(),
  //       listener: BannerAdListener(
  //         onAdLoaded: (Ad ad) {
  //           print('_preloadedBannerAd loaded.');
  //         },
  //         onAdFailedToLoad: (Ad ad, LoadAdError error) {
  //           print('BannerAd failed to preload: $error');
  //           ad.dispose();
  //           if (retryAttemptsBannerAd < maxRetryAttempts) {
  //             Future.delayed(
  //               Duration(
  //                   milliseconds: retryBaseDelayMillis * retryAttemptsBannerAd),
  //               () {
  //                 retryAttemptsBannerAd++;
  //                 preloadBannerAd();
  //               },
  //             );
  //           }
  //         },
  //       ),
  //     );
  //     _preloadedBannerAd!.load();
  //   }
  // }

  // static Widget getBannerAdWidget() {
  //   if (_currentBannerAd == null) {
  //     preloadBannerAd();
  //     return SizedBox.shrink();
  //   }

  //   final BannerAd adToShow = _currentBannerAd!;
  //   _currentBannerAd = _preloadedBannerAd;
  //   _preloadedBannerAd = null;
  //   preloadBannerAd();

  //   return Container(
  //     width: adToShow.size.width.toDouble(),
  //     height: adToShow.size.height.toDouble(),
  //     alignment: Alignment.center,
  //     child: AdWidget(ad: _currentBannerAd!),
  //   );
  // }
}
