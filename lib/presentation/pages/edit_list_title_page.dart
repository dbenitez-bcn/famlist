import 'package:famlist/presentation/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class EditListTitlePage extends StatelessWidget {
  final TextEditingController _titleTextField = TextEditingController();

  EditListTitlePage({Key? key}) : super(key: key);

  void _updateList(AppState state, NavigatorState navigator) async {
    await state.updateListTitle(_titleTextField.value.text);
    navigator.popUntil(ModalRoute.withName(Navigator.defaultRouteName));
  }

  @override
  Widget build(BuildContext context) {
    _titleTextField.text = AppState.of(context).currentList!.title;

    return Scaffold(
      appBar: AppBar(
        title: Text("edit_list".i18n()),
      ),
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
                      ? () => _updateList(
                            AppState.of(context),
                            Navigator.of(context),
                          )
                      : null,
                  child: Text("save".i18n()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
