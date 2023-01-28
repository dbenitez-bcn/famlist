import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:share_plus/share_plus.dart';

class ShareAppTile extends StatelessWidget {
  const ShareAppTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.share,
        color: Colors.grey,
      ),
      title: Text("share_app".i18n()),
      onTap: () async {
        var link = await _generateShareLink(context);
      await Share.share("${"download_famlist".i18n()} $link");
      FirebaseAnalytics.instance.logEvent(name: "app_shared");
      },
    );
  }

  Future<Uri> _generateShareLink(BuildContext context) async {
    final parameters = DynamicLinkParameters(
      link: Uri.parse(
          "https://famlist-app.web.app"),
      uriPrefix: "https://famlist.page.link",
      androidParameters: AndroidParameters(
        fallbackUrl: Uri.parse(
            "https://play.google.com/store/apps/details?id=com.logicgear.famlist"),
        packageName: "com.logicgear.famlist",
        minimumVersion: 2,
      ),
      iosParameters: const IOSParameters(
        bundleId: "com.logicgear.famlist",
        appStoreId: "1660114766",
        ipadBundleId: "com.logicgear.famlist",
        minimumVersion: "1.0.1",
      ),
      googleAnalyticsParameters: const GoogleAnalyticsParameters(
        source: "app",
        medium: "social",
        content: "share-",
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: "app_name".i18n(),
        description: "app_share_deep_link_description".i18n(),
        imageUrl: Uri.parse(
            "https://famlist-app.firebaseapp.com/img/app_icon.84091cf1.png"),
      ),
    );
    final shortLink =
    await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    return shortLink.shortUrl;
  }
}
