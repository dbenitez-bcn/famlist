import 'package:famlist/presentation/state/app_state.dart';
import 'package:famlist/services/lists_service.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../../domain/product.dart';

class EditProductPage extends StatelessWidget {
  final Product product;
  final TextEditingController _titleTextField = TextEditingController();
  final TextEditingController _descriptionTextField = TextEditingController();
  final ValueNotifier<int> _quantityController;

  EditProductPage(this.product, {Key? key})
      : _quantityController = ValueNotifier(product.quantity),
        super(key: key);

  void _updateProduct(BuildContext context) {
    product.title = _titleTextField.text;
    product.description = _descriptionTextField.text;
    product.quantity = _quantityController.value;
    ListsService.updateProduct(AppState.of(context).currentList!.id, product);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    _titleTextField.text = product.title;
    _descriptionTextField.text = product.description ?? "";
    return Scaffold(
      appBar: AppBar(title: Text("update_product_title".i18n())),
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
                  labelText: "product_label".i18n(),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      if (_quantityController.value > 1) {
                        _quantityController.value--;
                      }
                    },
                    child: const Circle(icon: Icons.remove)),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    height: 64,
                    width: 64,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 3.0),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: ValueListenableBuilder<int>(
                        valueListenable: _quantityController,
                        builder: (context, value, child) {
                          return Text(
                            "$value",
                            style: const TextStyle(fontSize: 24.0),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                    onTap: () => _quantityController.value++,
                    child: const Circle(icon: Icons.add)),
              ],
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _titleTextField,
              builder: (context, value, child) {
                return ElevatedButton(
                  onPressed: value.text.isNotEmpty
                      ? () => _updateProduct(context)
                      : null,
                  child: Text("update_label".i18n()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Circle extends StatelessWidget {
  final IconData icon;

  const Circle({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[300],
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 32.0,
      ),
    );
  }
}
