import 'package:famlist/presentation/pages/main_page.dart';
import 'package:famlist/presentation/pages/new_list_page.dart';
import 'package:famlist/presentation/pages/new_product_page.dart';
import 'package:famlist/presentation/state/list_state.dart';
import 'package:famlist/presentation/wigdet/custom_banner_ad.dart';
import 'package:famlist/services/ads_service.dart';
import 'package:famlist/services/lists_service.dart';
import 'package:famlist/utils/constants.dart';
import 'package:famlist/utils/famlist_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FamlistApp extends StatelessWidget {
  const FamlistApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['lib/i18n'];

    return AppState(
      child: AdsService(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: APP_NAME,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            LocalJsonLocalization.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('es', ''),
            Locale('ca', ''),
            Locale('pt', ''),
            Locale('fr', ''),
            Locale('it', ''),
          ],
          localeResolutionCallback: _localeResolution,
          theme: famlistTheme,
          routes: <String, WidgetBuilder>{
            '/newProduct': (BuildContext context) => const NewProductPage(),
            '/newList': (BuildContext context) => NewListPage(),
          },
          home: FutureBuilder<SharedPreferences>(
            future: SharedPreferences.getInstance(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    AppState.of(context).setSharedPreferences(snapshot.data!);
                    return FutureBuilder<void>(
                      future: _initializeApp(AppState.of(context)),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              return Scaffold(
                                body: Center(
                                  child: Text("app_start_error".i18n()),
                                ),
                              );
                            }
                            return Column(
                              children: const [
                                Expanded(
                                  child: MainPage(),
                                ),
                                CustomBannerAd(),
                              ],
                            );
                          default:
                            return const Scaffold(
                              body: Center(
                                  child: CircularProgressIndicator.adaptive()),
                            );
                        }
                      },
                    );
                  }
                  return Scaffold(
                    body: Center(
                      child: Text("app_start_error".i18n()),
                    ),
                  );
                default:
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator.adaptive()),
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  Locale? _localeResolution(locale, supportedLocales) {
    Locale userLocale = Locale(locale?.languageCode ?? "en", "");
    if (supportedLocales.contains(userLocale)) {
      return userLocale;
    }
    return const Locale('en', '');
  }

  Future<void> _initializeApp(AppState state) async {
    await FirebaseAuth.instance.signInAnonymously();

    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      String listId = initialLink.link.pathSegments[0];
      ListsService.addSharedList(listId);
      state.setList(listId);
    }
    FirebaseDynamicLinks.instance.onLink.listen((linkData) {
      String listId = linkData.link.pathSegments[0];
      ListsService.addSharedList(listId);
      state.setList(listId);
    });

    if (state.currentListId == null) {
      state.setList(await ListsService.addList("default_list_title".i18n()));
    }
  }
}
