import 'dart:io';

class AdManager {
  //Test Ads
  static String get bannerAdUnitTestId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitTestId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/2247696110";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitTestId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1712485313";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get nativeAdvancedTestId {
    return "ca-app-pub-3940256099942544/2247696110";
  }

  //
  ///////Release ads

  static String get lobbyBannerAd {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1929718553234881/7448667765';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get gameScreenBannerAd1 {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1929718553234881/9403967017';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1929718553234881/9403967017';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get gameScreenBannerAd2 {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1929718553234881/7808648462';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1929718553234881/7808648462';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }
}
