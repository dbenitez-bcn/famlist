import 'package:famlist/list.dart';
import 'package:famlist/presentation/state/app_state.dart';
import 'package:famlist/presentation/wigdet/listTiles/new_list_tile.dart';
import 'package:famlist/presentation/wigdet/listTiles/support_developer.dart';
import 'package:famlist/presentation/wigdet/shared_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class FamlistDrawer extends StatelessWidget {
  const FamlistDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("app_name".i18n(),
                    style: Theme.of(context).textTheme.headline3),
                Text("your_lists".i18n(),
                    style: Theme.of(context).textTheme.headlineSmall),
              ],
            ),
          ),
          const ListLists(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Divider(),
          ),
          const NewListTile(),
          const SupportDeveloperTile(),
        ],
      ),
    );
  }
}

class ListLists extends StatelessWidget {
  const ListLists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SharedList>>(
      initialData: AppState.of(context).initialUserLists,
      stream: AppState.of(context).userLists,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }
        return Column(
          children: snapshot.data!
              .map((SharedList list) => SharedListTile(list: list))
              .toList(),
        );
      },
    );
  }
}
