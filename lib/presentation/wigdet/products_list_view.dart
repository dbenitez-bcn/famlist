import 'package:famlist/list.dart';
import 'package:famlist/presentation/state/list_state.dart';
import 'package:famlist/presentation/wigdet/product_view.dart';
import 'package:famlist/services/lists_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../../domain/product.dart';
import 'empty_list.dart';

class ProductsListView extends StatelessWidget {
  const ProductsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SharedList?>(
      initialData: AppState.of(context).currentList,
      stream: AppState.of(context).currentListStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }
        return StreamBuilder(
          stream: ListsService.getProducts(snapshot.data!.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return _buildList(snapshot.data!);
              }
              return const EmptyList();
            } else if (snapshot.hasError) {
              FirebaseCrashlytics.instance
                  .recordError(snapshot.error, snapshot.stackTrace);
              return Text("connection_error".i18n());
            } else {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
          },
        );
      },
    );
  }

  Widget _buildList(List<Product> products) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListView.builder(
        itemBuilder: (context, index) => Dismissible(
          key: Key(products[index].id),
          direction: DismissDirection.endToStart,
          onDismissed: (_) {
            ListsService.removeProduct(
                AppState.of(context).currentList!.id, products[index].id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text("product_deletion".i18n([products[index].title]))),
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
      ),
    );
  }
}
