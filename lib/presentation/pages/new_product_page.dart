import 'package:famlist/presentation/state/list_state.dart';
import 'package:famlist/services/ads_service.dart';
import 'package:famlist/services/lists_service.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class NewProductPage extends StatefulWidget {
  const NewProductPage({Key? key}) : super(key: key);

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  final TextEditingController _titleTextField = TextEditingController();
  final TextEditingController _descriptionTextField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("add_product".i18n())),
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
                  hintText: "product_name".i18n(),
                  labelText: "name".i18n(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: TextField(
                controller: _descriptionTextField,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                minLines: 1,
                maxLines: 3,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "product_description_hint_text".i18n(),
                  labelText: "product_description_label".i18n(),
                ),
              ),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _titleTextField,
              builder: (context, value, child) {
                final String? currentListId =
                    AppState.of(context).currentListId;
                return ElevatedButton(
                  onPressed: value.text.isNotEmpty && currentListId != null
                      ? () {
                          ListsService.addProduct(
                              currentListId,
                              _titleTextField.value.text,
                              _descriptionTextField.value.text);
                          AppState.of(context).increaseProductAdded();
                          AdsService.of(context).showInterstitial();
                          Navigator.pop(context);
                        }
                      : null,
                  child: Text("create".i18n()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
