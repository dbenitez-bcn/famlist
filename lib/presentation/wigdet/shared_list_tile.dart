import 'package:famlist/list.dart';
import 'package:famlist/presentation/state/app_state.dart';
import 'package:flutter/material.dart';

class SharedListTile extends StatelessWidget {
  final SharedList list;

  const SharedListTile({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selectedColor: Colors.black87,
      selectedTileColor: Theme.of(context).primaryColor.withAlpha(75),
      selected: list.id == AppState.of(context).currentList!.id,
      title: Text(list.title),
      leading: const Icon(
        Icons.list,
        color: Colors.grey,
      ),
      onTap: () {
        AppState.of(context).setList(list);
        Navigator.pop(context);
      },
    );
  }
}
