import 'package:famlist/services/ads_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CustomBannerAd extends StatelessWidget {
  const CustomBannerAd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ad = AdsService.of(context).bottomBanner;
    return SizedBox(
      width: double.infinity,
      height: AdSize.banner.height.toDouble(),
      child: FutureBuilder<void>(
        future: ad.load(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              FirebaseAnalytics.instance.logEvent(name: "ad_failed_to_load");
              FirebaseCrashlytics.instance
                  .recordError(snapshot.error, snapshot.stackTrace);
              return const SizedBox();
            }
            return AdWidget(
              ad: ad,
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
