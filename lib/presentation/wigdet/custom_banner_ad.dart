import 'package:famlist/services/ads_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CustomBannerAd extends StatelessWidget {
  const CustomBannerAd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AdSize.banner.height.toDouble(),
      child: AdWidget(
        ad: AdsService.of(context).bottomBanner,
      ),
    );
  }
}
