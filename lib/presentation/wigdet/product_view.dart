import 'package:famlist/presentation/pages/edit_product_page.dart';
import 'package:famlist/presentation/state/list_state.dart';
import 'package:famlist/services/lists_service.dart';
import 'package:flutter/material.dart';

import '../../domain/product.dart';

class ProductView extends StatelessWidget {
  final Product _product;

  const ProductView(this._product, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          // onTap: () =>,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditProductPage(_product)));
          },
          title: Text(_product.title),
          trailing: GestureDetector(onTap: () =>
              ListsService.increaseQuantity(
                  AppState
                      .of(context)
                      .currentListId!, _product),
              child: Text("x${_product.quantity}")),
        ),
      ),
    );
  }
}
