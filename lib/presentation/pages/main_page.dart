import 'package:famlist/presentation/state/list_state.dart';
import 'package:famlist/presentation/wigdet/famlist_drawer.dart';
import 'package:famlist/services/lists_service.dart';
import 'package:famlist/utils/literals.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  final String listId;

  const MainPage({Key? key, required this.listId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: StreamBuilder<String>(
            initialData: listId,
            stream: ListState.of(context).currentList,
            builder: (context, snapshot) {
              return FutureBuilder(
                future: ListsService.getListTitle(snapshot.data!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Text(snapshot.data ?? appName);
                  } else {
                    return const SizedBox();
                  }
                },
              );
            },
          ),
        ),
        drawer: const FamlistDrawer(),
        body: const Text("Hello hello"));
  }
}
