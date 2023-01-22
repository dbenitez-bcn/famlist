import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../../../services/ads_service.dart';

class SupportDeveloperTile extends StatelessWidget {
  const SupportDeveloperTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.play_circle_outline,
        color: Colors.grey,
      ),
      title: Text("support_developer".i18n()),
      onTap: () {
        AdsService.of(context).supportDeveloper(() {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("support_developer_message".i18n()),
            ),
          );
        });
        FirebaseAnalytics.instance.logEvent(name: "developer_supported");
      },
    );
  }
}
