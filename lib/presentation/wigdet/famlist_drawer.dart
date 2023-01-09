import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famlist/list.dart';
import 'package:famlist/presentation/state/app_state.dart';
import 'package:famlist/services/ads_service.dart';
import 'package:famlist/services/lists_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
          ListLists(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Divider(),
          ),
          InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            child: ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: Text("add_list".i18n()),
            ),
            onTap: () => Navigator.pushNamed(context, '/newList'),
          ),
          InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            child: ListTile(
              leading: const Icon(Icons.play_circle_outline),
              title: Text("support_developer".i18n()),
            ),
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
          ),
        ],
      ),
    );
  }
}

class ListLists extends StatelessWidget {
  ListLists({Key? key}) : super(key: key);
  final Stream<DocumentSnapshot<Map<String, dynamic>>> _listsStream =
      FirebaseFirestore.instance
          .collection("shared_lists")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _listsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> lists = snapshot.data!.data()!["lists"];
          return Column(
            children: lists
                .map(
                  (id) => FutureBuilder<SharedList?>(
                    future: ListsService.getSharedListById(id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListTile(
                          title: Text(snapshot.data!.title),
                          leading: const Icon(Icons.list),
                          onTap: () {
                            AppState.of(context).setList(snapshot.data!);
                            Navigator.pop(context);
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                )
                .toList(),
          );
        }
        return const SizedBox();
      },
    );
  }
}
