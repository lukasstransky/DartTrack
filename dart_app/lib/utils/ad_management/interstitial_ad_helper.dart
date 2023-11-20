import 'dart:io';

class InterstitialAdHelper {
  // static InterstitialAd? _interstitialAd;

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
    // InterstitialAd.load(
    //   adUnitId: _interstitialAdUnitId,
    //   request: AdRequest(),
    //   adLoadCallback: InterstitialAdLoadCallback(
    //     onAdLoaded: (InterstitialAd ad) {
    //       _interstitialAd = ad;
    //       retryAttemptsInterstitialAd = 0;
    //     },
    //     onAdFailedToLoad: (LoadAdError error) {
    //       print('InterstitialAd failed to load: $error');
    //       if (retryAttemptsInterstitialAd < maxRetryAttempts) {
    //         Future.delayed(
    //             Duration(
    //                 milliseconds:
    //                     (retryBaseDelayMillis * retryAttemptsBannerAd)), () {
    //           retryAttemptsInterstitialAd++;
    //           loadInterstitialAd();
    //         });
    //       }
    //     },
    //   ),
    // );
  }

  static void showInterstitialAd(Function() onAdDismissedCallback) {
    // if (_interstitialAd == null) {
    print('Warning: attempt to show interstitial before loaded.');
    return;
    // }
    // _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
    //   onAdShowedFullScreenContent: (InterstitialAd ad) {
    //     print('Interstitial ad shown.');
    //   },
    //   onAdDismissedFullScreenContent: (InterstitialAd ad) {
    //     onAdDismissedCallback();
    //     ad.dispose();

    //     print('Interstitial ad dismissed.');
    //     loadInterstitialAd();
    //   },
    //   onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
    //     print('Interstitial ad failed to show: $error');
    //     ad.dispose();
    //     loadInterstitialAd();
    //   },
    // );
    // _interstitialAd!.show();
    // _interstitialAd = null;
  }
}
