import 'package:famlist/presentation/state/list_state.dart';
import 'package:famlist/presentation/wigdet/product_view.dart';
import 'package:famlist/services/lists_service.dart';
import 'package:flutter/material.dart';

import '../../domain/product.dart';
import '../../utils/literals.dart';
import 'empty_list.dart';

class ProductsListView extends StatelessWidget {
  const ProductsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: AppState.of(context).currentListId,
      stream: AppState.of(context).currentListStream,
      builder: (context, snapshot) {
        return StreamBuilder(
            stream: ListsService.getProducts(snapshot.data!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return _buildList(snapshot.data!);
                }
                return const EmptyList();
              } else if (snapshot.hasError) {
                return const Text(connectionError);
              } else {
                return const Center(child: CircularProgressIndicator.adaptive());
              }
            });
      }
    );
  }

  Widget _buildList(List<Product> products) {
    return ListView.builder(
      itemBuilder: (context, index) => Dismissible(
        key: Key(products[index].id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) {
          ListsService.removeProduct(AppState.of(context).currentListId, products[index].id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
              Text(productDeletion(products[index].title)),
            ),
          );
        },
        background: Container(
          color: Colors.red[700],
          child: const Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 24.0,
              ),
            ),
          ),
        ),
        child: ProductView(products[index]),
      ),
      itemCount: products.length,
    );
  }
}
