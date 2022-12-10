import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famlist/famlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  String host = Platform.isAndroid ? '10.0.2.2' : '127.0.0.1';
  FirebaseFirestore.instance.settings = Settings(
    host: "$host:8080",
    sslEnabled: false,
    persistenceEnabled: false,
  );
  await FirebaseAuth.instance.useAuthEmulator(host, 9099);
  await FirebaseAuth.instance.signOut();
  runApp(const Famlist());
}
