import 'package:famlist/presentation/pages/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Famlist extends StatelessWidget {
  const Famlist({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Famlist',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      // routes: <String, WidgetBuilder>{
      //   '/newProduct': (BuildContext context) => NewProductPage(),
      //   '/newList': (BuildContext context) => NewListPage(),
      // },
      home: FutureBuilder<void>(
        future: _initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _loaderIndicator();
          } else if (snapshot.hasError ||
              FirebaseAuth.instance.currentUser == null) {
            print(snapshot.error);
            return _message("Algo salió mal. Por favor, intentalo mas tarde");
          } else {
            return const MainPage();
          }
        },
      ),
    );
  }

  Future<void> _initializeApp() async {
    await FirebaseAuth.instance.signInAnonymously();
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
