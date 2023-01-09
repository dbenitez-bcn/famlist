import 'package:famlist/presentation/state/app_state.dart';
import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart"
    show defaultTargetPlatform, TargetPlatform;
import "package:flutter/material.dart";
import "package:localization/localization.dart";

class DeleteListMenuItem {
  static PopupMenuItem<Function> build(BuildContext context) {
    return PopupMenuItem<Function>(
      child: Text("delete".i18n()),
      value: () async {
        defaultTargetPlatform == TargetPlatform.android
            ? await _showAndroidDialog(context)
            : await _showCupertinoDialog(context);
      },
    );
  }

  static _showCupertinoDialog(BuildContext context) async {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("delete_list_dialog_title".i18n()),
          content: Text("delete_list_dialog_body"
              .i18n([AppState.of(context).currentList!.title])),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              isDefaultAction: true,
              isDestructiveAction: true,
              onPressed: () async {
                Navigator.pop(context);
                await AppState.of(context).removeCurrentList();
              },
              child: Text("yes".i18n()),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("no".i18n()),
            ),
          ],
        );
      },
    );
  }

  static _showAndroidDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("delete_list_dialog_title".i18n()),
            content: Text("delete_list_dialog_body"
                .i18n([AppState.of(context).currentList!.title])),
            actions: [
              TextButton(
                child: Text(
                  "no".i18n(),
                  style: const TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  "yes".i18n(),
                  style: const TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await AppState.of(context).removeCurrentList();
                },
              ),
            ],
          );
        });
  }
}
