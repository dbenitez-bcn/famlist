import 'package:famlist/domain/dtos/app_initialization_dto.dart';
import 'package:famlist/list.dart';
import 'package:famlist/material_app_error.dart';
import 'package:famlist/presentation/pages/main_page.dart';
import 'package:famlist/presentation/pages/new_list_page.dart';
import 'package:famlist/presentation/pages/new_product_page.dart';
import 'package:famlist/presentation/pages/welcome_page.dart';
import 'package:famlist/presentation/state/app_state.dart';
import 'package:famlist/services/ads_service.dart';
import 'package:famlist/services/lists_service.dart';
import 'package:famlist/utils/constants.dart';
import 'package:famlist/utils/famlist_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'presentation/pages/first_list_page.dart';

class FamlistApp extends StatelessWidget {
  const FamlistApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['lib/i18n'];

    var appLoading = MaterialApp(
      title: APP_NAME,
      theme: famlistTheme,
      home: const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      ),
    );

    return FutureBuilder<AppInitializationDto>(
        future: _initializeApp(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError) {
                FirebaseCrashlytics.instance
                    .recordError(snapshot.error, snapshot.stackTrace);
                return const MaterialAppError();
              }
              return AppState(
                snapshot.data!.preferences,
                snapshot.data!.sharedList,
                child: AdsService(
                  child: MaterialApp(
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
                      '/newProduct': (BuildContext context) =>
                          const NewProductPage(),
                      '/newList': (BuildContext context) => NewListPage(),
                      '/welcomeList': (BuildContext context) =>
                          WelcomeListPage(),
                      '/welcome': (BuildContext context) => const WelcomePage(),
                      // '/home': (BuildContext context) => const MainPage(),
                    },
                    home: const MainPage(),
                  ),
                ),
              );
            default:
              return appLoading;
          }
        });
  }

  Locale? _localeResolution(locale, supportedLocales) {
    Locale userLocale = Locale(locale?.languageCode ?? "en", "");
    if (supportedLocales.contains(userLocale)) {
      return userLocale;
    }
    return const Locale('en', '');
  }

  Future<AppInitializationDto> _initializeApp() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await FirebaseAuth.instance.signInAnonymously();

    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      var pathArray = initialLink.link.pathSegments;
      if (pathArray.isNotEmpty) {
        SharedList? list = await ListsService.getSharedListById(pathArray[0]);
        if (list != null) {
          await ListsService.addSharedList(list.id);
          await preferences.setString(LAST_LIST_ID_KEY, list.id);
          return AppInitializationDto(preferences, list);
        }
      }
    }

    String? listId = preferences.getString(LAST_LIST_ID_KEY);
    if (listId != null) {
      return AppInitializationDto(
          preferences, await ListsService.getSharedListById(listId));
    }
    return AppInitializationDto(preferences, null);
  }
}
