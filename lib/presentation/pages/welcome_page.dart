import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "welcome_title".i18n(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              "welcome_subtitle".i18n(),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/welcomeList'),
                child: Text("lets_go".i18n()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
