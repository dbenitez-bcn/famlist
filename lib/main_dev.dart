import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famlist/famlist.dart';
import 'package:famlist/utils/constants.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(testDeviceIds: ["DD996A2C5DBCE4FC85E32DF07AD9BA4A", "A8CA11D5DD995E9F339E8FDD05103001"])
  );
  await Firebase.initializeApp();
  String host = Platform.isAndroid ? '10.0.2.2' : '127.0.0.1';
  FirebaseFirestore.instance.settings = Settings(
    host: "$host:8080",
    sslEnabled: false,
    persistenceEnabled: false,
  );
  await FirebaseAuth.instance.useAuthEmulator(host, 9099);
  await FirebaseAuth.instance.signOut();
  var shared = await SharedPreferences.getInstance();
  shared.remove(LAST_LIST_ID_KEY);
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  runApp(const FamlistApp());
}
