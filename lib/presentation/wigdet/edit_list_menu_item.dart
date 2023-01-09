import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class EditListMenuItem {

  static PopupMenuItem build(BuildContext context) {
    return PopupMenuItem(
      child: Text("edit".i18n()),
      onTap: () async {
      },
    );
  }
}
