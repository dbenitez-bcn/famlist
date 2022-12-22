import 'package:famlist/presentation/state/list_state.dart';
import 'package:famlist/presentation/wigdet/famlist_drawer.dart';
import 'package:famlist/services/lists_service.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:share_plus/share_plus.dart';

import '../wigdet/products_list_view.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<String>(
          initialData: AppState.of(context).currentListId,
          stream: AppState.of(context).currentListStream,
          builder: (context, snapshot) {
            return FutureBuilder(
              future: ListsService.getListTitle(snapshot.data!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Text(snapshot.data!);
                } else {
                  return const SizedBox();
                }
              },
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final link = await _generateShareLink(context);
              await Share.share("${"share_list_link_description".i18n()} $link");
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      drawer: const FamlistDrawer(),
      body: const ProductsListView(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, '/newProduct'),
      ),
    );
  }

  Future<Uri> _generateShareLink(BuildContext context) async {
    final parameters = DynamicLinkParameters(
      link: Uri.parse("https://famlist-app.web.app/${AppState.of(context).currentListId}"),
      uriPrefix: "https://famlist.page.link",
      androidParameters: AndroidParameters(
        fallbackUrl: Uri.parse("https://play.google.com/store/apps/details?id=com.logicgear.famlist"),
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
        imageUrl: Uri.parse("https://famlist-app.firebaseapp.com/img/logotype.4ab23ff2.jpg"),
      ),
    );
    final shortLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    return shortLink.shortUrl;
  }

}
