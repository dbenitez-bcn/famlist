import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CustomBannerAd extends StatefulWidget {
  const CustomBannerAd({Key? key}) : super(key: key);

  @override
  State<CustomBannerAd> createState() => _CustomBannerAdState();
}

class _CustomBannerAdState extends State<CustomBannerAd> {
  late BannerAd bannerAd;
  bool isBannerAdLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716',
      listener: BannerAdListener(onAdFailedToLoad: (ad, error) {
        ad.dispose();
      }, onAdLoaded: (ad) {
        setState(() {
          isBannerAdLoaded = true;
        });
      }),
      request: const AdRequest(),
    );
    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return isBannerAdLoaded
        ? SizedBox(
            width: double.infinity,
            height: AdSize.banner.height.toDouble(),
            child: AdWidget(
              ad: bannerAd,
            ),
          )
        : SizedBox(
            width: double.infinity,
            height: AdSize.banner.height.toDouble(),
          );
  }
}
