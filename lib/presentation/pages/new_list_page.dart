import 'package:famlist/presentation/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class NewListPage extends StatelessWidget {
  final TextEditingController _titleTextField = TextEditingController();

  NewListPage({Key? key}) : super(key: key);

  void _createList(AppState state, NavigatorState navigator) async {
    await state.addList(_titleTextField.value.text);
    navigator.popUntil(ModalRoute.withName(Navigator.defaultRouteName));
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
                autofocus: true,
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
                  onPressed: value.text.isNotEmpty
                      ? () => _createList(
                            AppState.of(context),
                            Navigator.of(context),
                          )
                      : null,
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
