import 'package:google_mobile_ads/google_mobile_ads.dart';

class OpenAdManager{

  static bool haveShowed = false;

  void createOpenAd(String key, Function callback) {
    AppOpenAd.load(
        adUnitId: key,
        request: AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            appOpenAdd = ad;
            appOpenAdd!.setImmersiveMode(true);
            _showAppOpenAd(callback);
          },
          onAdFailedToLoad: (error) {
            print('AppOpenAd failed to load: $error');
            // Handle the error.
          },
        ),
        orientation: AppOpenAd.orientationPortrait);
  }

  void _showAppOpenAd(Function callback) {
    if (appOpenAdd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    appOpenAdd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (AppOpenAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (AppOpenAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        callback();
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (AppOpenAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
    );
    appOpenAdd!.show();
    appOpenAdd = null;
  }

  AppOpenAd? appOpenAdd;
}