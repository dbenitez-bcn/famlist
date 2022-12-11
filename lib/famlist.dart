import 'package:famlist/presentation/pages/main_page.dart';
import 'package:famlist/presentation/pages/new_list_page.dart';
import 'package:famlist/presentation/pages/new_product_page.dart';
import 'package:famlist/presentation/state/list_state.dart';
import 'package:famlist/services/lists_service.dart';
import 'package:famlist/utils/constants.dart';
import 'package:famlist/utils/literals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Famlist extends StatelessWidget {
  const Famlist({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: _initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _loaderIndicator();
        } else if (snapshot.hasError ||
            FirebaseAuth.instance.currentUser == null) {
          return _message(appStartError);
        } else {
          return ListState(
            sharedPreferences: snapshot.data!,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: appName,
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
              home: const MainPage(),
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
      await preferences.setString(
          LAST_LIST_ID_KEY, await ListsService.addList(defaultListTitle));
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
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: home,
    );
  }
}
