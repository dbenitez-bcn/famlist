import 'package:famlist/presentation/wigdet/delete_list_menu_item.dart';
import 'package:famlist/presentation/wigdet/edit_list_menu_item.dart';
import 'package:flutter/material.dart';

import 'share_list_menu_item.dart';

class AppBarMenu extends StatelessWidget {
  const AppBarMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Function>(
      onSelected: (callback) => callback(),
      itemBuilder: (context) {
        return [
          ShareListMenuItem.build(context),
          EditListMenuItem.build(context),
          DeleteListMenuItem.build(context),
        ];
      },
    );
  }
}
