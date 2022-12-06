import 'package:famlist/presentation/state/current_list.dart';
import 'package:famlist/services/lists_service.dart';
import 'package:flutter/material.dart';

import '../../utils/literals.dart';

class NewListPage extends StatelessWidget {
  final TextEditingController _titleTextField = TextEditingController();

  NewListPage({Key? key}) : super(key: key);

  void _createList(BuildContext context) {
    ListsService
        .addList(_titleTextField.value.text)
        .then((value) => CurrentList.of(context).setList(value));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(addList)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: TextField(
                controller: _titleTextField,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: listName,
                  labelText: name,
                ),
              ),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _titleTextField,
              builder: (context, value, child) {
                return ElevatedButton(
                  onPressed:
                      value.text.isNotEmpty ? () => _createList(context) : null,
                  child: const Text(create),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
