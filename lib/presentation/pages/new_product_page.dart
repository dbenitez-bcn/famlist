import 'package:famlist/presentation/state/list_state.dart';
import 'package:famlist/services/lists_service.dart';
import 'package:flutter/material.dart';

import '../../utils/literals.dart';

class NewProductPage extends StatefulWidget {
  const NewProductPage({Key? key}) : super(key: key);

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  final TextEditingController _titleTextField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(addProduct)),
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
                  hintText: productName,
                  labelText: name,
                ),
              ),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _titleTextField,
              builder: (context, value, child) {
                final String currentListId =
                    AppState.of(context).currentListId;
                return ElevatedButton(
                  onPressed: value.text.isNotEmpty && currentListId.isNotEmpty
                      ? () {
                          ListsService.addProduct(
                              currentListId, _titleTextField.value.text);
                          AppState.of(context).increaseProductAdded();
                          Navigator.pop(context);
                        }
                      : null,
                  child: const Text(create),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
