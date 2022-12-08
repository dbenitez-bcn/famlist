import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famlist/list.dart';
import 'package:famlist/presentation/state/list_state.dart';
import 'package:famlist/services/lists_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/literals.dart';

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
                Text(appName, style: Theme.of(context).textTheme.headline3),
                Text(yourLists,
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
            child: const ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text(addList),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/newList');
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
                  (id) => FutureBuilder<SharedList>(
                    future: ListsService.getSharedListById(id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListTile(
                          title: Text(snapshot.data!.title),
                          leading: const Icon(Icons.list),
                          onTap: () {
                            ListState.of(context).setList(snapshot.data!.id);
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
