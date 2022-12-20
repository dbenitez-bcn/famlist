import 'package:famlist/presentation/pages/main_page.dart';
import 'package:famlist/presentation/pages/new_list_page.dart';
import 'package:famlist/presentation/pages/new_product_page.dart';
import 'package:famlist/presentation/state/list_state.dart';
import 'package:famlist/presentation/wigdet/custom_banner_ad.dart';
import 'package:famlist/services/lists_service.dart';
import 'package:famlist/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Famlist extends StatelessWidget {
  const Famlist({super.key});

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['lib/i18n'];
    return FutureBuilder<SharedPreferences>(
      future: _initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _loaderIndicator();
        } else if (snapshot.hasError ||
            FirebaseAuth.instance.currentUser == null) {
          return _message("app_start_error".i18n());
        } else {
          return AppState(
            sharedPreferences: snapshot.data!,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Famlist",
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
              ],
              localeResolutionCallback: (locale, supportedLocales) {
                Locale userLocale = Locale(locale?.languageCode ?? "en", "");
                if (supportedLocales.contains(userLocale)) {
                  return userLocale;
                }
                return const Locale('en', '');
              },
              theme: ThemeData(
                primaryColor: const Color(0xFFB8E123),
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFFB8E123),
                  primary: const Color(0xFFB8E123),
                  onPrimary: Colors.black87,
                  secondary: const Color(0xFFB8E123),
                  onSecondary: Colors.black87,
                ),
                textTheme: const TextTheme(
                  headline3: TextStyle(color: Colors.black87),
                ),
              ),
              routes: <String, WidgetBuilder>{
                '/newProduct': (BuildContext context) => const NewProductPage(),
                '/newList': (BuildContext context) => NewListPage(),
              },
              home: Column(
                children: const [
                  Expanded(
                    child: MainPage(),
                  ),
                  CustomBannerAd(),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<SharedPreferences> _initializeApp() async {
    var preferences = await SharedPreferences.getInstance();
    UserCredential userCredentials =
        await FirebaseAuth.instance.signInAnonymously();
    if (userCredentials.additionalUserInfo != null &&
        userCredentials.additionalUserInfo!.isNewUser) {
      await preferences.setString(LAST_LIST_ID_KEY,
          await ListsService.addList("default_list_title".i18n()));
    }
    return preferences;
  }

  Widget _message(String message) {
    return _baseApp(
      home: Scaffold(
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }

  Widget _loaderIndicator() {
    // TODO: Add splash screen to load
    return _baseApp(
      home: const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }

  Widget _baseApp({required Widget home}) {
    return MaterialApp(
      title: 'Famlist',
      home: home,
    );
  }
}
