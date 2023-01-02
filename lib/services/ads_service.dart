import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService extends InheritedWidget {
  InterstitialAd? _interstitialAd;

  AdsService({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child) {
    loadInterstitial();
  }

  void showInterstitial() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
    }
  }

  void loadInterstitial() {
    InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-9458621217720467/4770162715'
          : 'ca-app-pub-9458621217720467/9639346018',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              ad.dispose();
              _interstitialAd = null;
            },
            onAdFailedToShowFullScreenContent:
                (InterstitialAd ad, AdError error) {
              ad.dispose();
              _interstitialAd = null;
            },
          );
          _interstitialAd = ad;
        }, onAdFailedToLoad: (LoadAdError error) {  },
      ),
    );
  }

  @override
  bool updateShouldNotify(covariant AdsService oldWidget) => true;

  static AdsService of(BuildContext context) {
    final AdsService? result =
        context.dependOnInheritedWidgetOfExactType<AdsService>();
    assert(result != null, 'No AdsService found in context');
    return result!;
  }
}
