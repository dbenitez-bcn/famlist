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
      home: Scaffold(
        body: Center(
          child: Text("app_start_error".i18n()),
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
}
