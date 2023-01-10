import 'package:famlist/utils/constants.dart';
import 'package:famlist/utils/famlist_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';

class MaterialAppError extends StatelessWidget {
  const MaterialAppError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_NAME,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        LocalJsonLocalization.delegate,
      ],
      supportedLocales: SUPPORTED_LOCALES,
      localeResolutionCallback: _localeResolution,
      theme: famlistTheme,
      home: const AppStartErrorPage(),
    );
  }

  Locale? _localeResolution(locale, supportedLocales) {
    Locale userLocale = Locale(locale?.languageCode ?? "en", "");
    if (supportedLocales.contains(userLocale)) {
      return userLocale;
    }
    return const Locale('en', '');
  }
}

class AppStartErrorPage extends StatelessWidget {
  const AppStartErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("app_start_error".i18n()),
      ),
    );
  }
}

