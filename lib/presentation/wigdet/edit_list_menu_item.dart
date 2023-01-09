import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class EditListMenuItem {
  static PopupMenuItem<Function> build(BuildContext context) {
    return PopupMenuItem<Function>(
      child: Text("edit".i18n()),
      value: () => Navigator.of(context).pushNamed('/editList'),
    );
  }
}
