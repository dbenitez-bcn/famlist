import 'dart:io';

import 'package:famlist/famlist.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // String host = Platform.isAndroid ? '10.0.2.2' : '127.0.0.1';
  // FirebaseFirestore.instance.settings = Settings(
  //   host: "$host:8080",
  //   sslEnabled: false,
  //   persistenceEnabled: false,
  // );
  // await FirebaseAuth.instance.useAuthEmulator(host, 9099);
  runApp(const Famlist());
}
