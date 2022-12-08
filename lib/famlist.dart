import 'package:famlist/presentation/pages/main_page.dart';
import 'package:famlist/presentation/pages/new_list_page.dart';
import 'package:famlist/presentation/state/list_state.dart';
import 'package:famlist/services/lists_service.dart';
import 'package:famlist/utils/literals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Famlist extends StatelessWidget {
  final SharedPreferences _sharedPreferences;
  const Famlist(this._sharedPreferences, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListState(
      sharedPreferences: _sharedPreferences,
      child: MaterialApp(
        title: 'Famlist',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        routes: <String, WidgetBuilder>{
          //   '/newProduct': (BuildContext context) => NewProductPage(),
          '/newList': (BuildContext context) => NewListPage(),
        },
        home: FutureBuilder<String>(
          future: _initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _loaderIndicator();
            } else if (snapshot.hasError ||
                FirebaseAuth.instance.currentUser == null) {
              return _message(appStartError);
            } else {
              ListState.of(context).setList(snapshot.data!);
              return MainPage(listId: snapshot.data!);
            }
          },
        ),
      ),
    );
  }

  Future<String> _initializeApp() async {
    UserCredential userCredentials =
        await FirebaseAuth.instance.signInAnonymously();
    if (userCredentials.additionalUserInfo != null &&
        userCredentials.additionalUserInfo!.isNewUser) {
      return await ListsService.addList(defaultListTitle);
    }
    return _sharedPreferences.getString("last_list") ?? "";
  }

  Widget _message(String message) {
    return Scaffold(
      body: Center(
        child: Text(message),
      ),
    );
  }

  Widget _loaderIndicator() {
    // TODO: Add splash screen to load
    return const Scaffold(
      body: Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
