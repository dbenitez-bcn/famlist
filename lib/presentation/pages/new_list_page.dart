import 'package:famlist/presentation/state/list_state.dart';
import 'package:famlist/services/lists_service.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class NewListPage extends StatelessWidget {
  final TextEditingController _titleTextField = TextEditingController();

  NewListPage({Key? key}) : super(key: key);

  void _createList(BuildContext context) {
    AppState state = AppState.of(context);
    ListsService
        .addList(_titleTextField.value.text)
        .then((value) => state.setList(value));
    Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("add_list".i18n())),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: TextField(
                controller: _titleTextField,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "list_name".i18n(),
                  labelText: "name".i18n(),
                ),
              ),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _titleTextField,
              builder: (context, value, child) {
                return ElevatedButton(
                  onPressed:
                      value.text.isNotEmpty ? () => _createList(context) : null,
                  child: Text("create".i18n()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
