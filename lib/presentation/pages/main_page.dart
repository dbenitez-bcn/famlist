import 'package:famlist/presentation/state/list_state.dart';
import 'package:famlist/presentation/wigdet/famlist_drawer.dart';
import 'package:famlist/services/lists_service.dart';
import 'package:famlist/utils/literals.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  final String title;

  const MainPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: StreamBuilder<String>(
            initialData: title,
            stream: ListState.of(context).currentList,
            builder: (context, snapshot) {
              return FutureBuilder(
                future: ListsService.getListTitle(snapshot.data!),
                builder: (context, snapshot) {
                  return Text(snapshot.data ?? appName);
                },
              );
            },
          ),
        ),
        drawer: const FamlistDrawer(),
        body: const Text("Hello hello"));
  }
}
