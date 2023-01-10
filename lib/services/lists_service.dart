import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famlist/list.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/product.dart';

class ListsService {
  static Future<SharedList> addList(String title) async {
    FirebaseAnalytics.instance
        .logEvent(name: "list_created"); // TODO: Move to app state
    DocumentReference newList =
        await FirebaseFirestore.instance.collection("lists").add({
      "title": title,
      "created_at": FieldValue.serverTimestamp(),
    });
    return await addSharedList(newList.id);
  }

  static Future<void> updateList(SharedList list) async {
    FirebaseAnalytics.instance
        .logEvent(name: "list_updated"); // TODO: Move to app state
    await FirebaseFirestore.instance
        .collection("lists")
        .doc(list.id)
        .update({"title": list.title});
  }

  static Future<SharedList> addSharedList(String listId) async {
    await FirebaseFirestore.instance
        .collection("shared_lists")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(
      {
        "lists": FieldValue.arrayUnion([listId])
      },
      SetOptions(merge: true),
    );
    return (await getSharedListById(listId))!;
  }

  static Future<SharedList> removeSharedList(String listId) async {
    await FirebaseFirestore.instance
        .collection("shared_lists")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(
      {
        "lists": FieldValue.arrayRemove([listId])
      },
      SetOptions(merge: true),
    );
    return (await getSharedListById(listId))!;
  }

  static Future<SharedList?> getSharedListById(String id) async {
    DocumentSnapshot<Map<String, dynamic>> listDocument =
        await FirebaseFirestore.instance.collection("lists").doc(id).get();

    if (listDocument.exists) {
      return SharedList(listDocument.id, listDocument.data()!["title"]);
    }
    return null;
  }

  static addProduct(String listId, String title, String? description) {
    FirebaseAnalytics.instance
        .logEvent(name: "product_added"); // TODO: Move to app state
    FirebaseFirestore.instance.collection("lists/$listId/products").add({
      "title": title,
      "quantity": 1,
      "description": description,
      "created_at": FieldValue.serverTimestamp(),
    });
  }

  static void increaseQuantity(String listId, Product product) async {
    await FirebaseFirestore.instance
        .doc("lists/$listId/products/${product.id}")
        .update({
      "quantity": product.quantity + 1,
    });
  }

  static void removeProduct(String listId, String productId) {
    FirebaseAnalytics.instance
        .logEvent(name: "product_deleted"); // TODO: Move to app state
    FirebaseFirestore.instance
        .collection("lists/$listId/products")
        .doc(productId)
        .delete();
  }

  static void updateProduct(String listId, Product product) async {
    FirebaseAnalytics.instance
        .logEvent(name: "product_updated"); // TODO: Move to app state
    await FirebaseFirestore.instance
        .doc("lists/$listId/products/${product.id}")
        .update({
      "title": product.title,
      "description": product.description,
      "quantity": product.quantity,
    });
  }

  static Stream<List<Product>> getProducts(String listId) {
    return FirebaseFirestore.instance
        .collection("lists/$listId/products")
        .snapshots()
        .map((event) => event.docs.map(_mapToProduct).toList());
  }

  static Stream<List<SharedList>> getSharedLists() {
    return FirebaseFirestore.instance
        .collection("shared_lists")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map(_getLists)
        .asyncMap(_mapLists);
  }

  static Future<SharedList?> getFirstSharedList() async {
    var foo = await FirebaseFirestore.instance
        .collection("shared_lists")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    List<dynamic> ids = foo["lists"];
    if (ids.isNotEmpty) {
      return await getSharedListById(ids[0]);
    }
    return null;
  }

  static List<dynamic> _getLists(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      return document.data()!["lists"];
    }
    return [];
  }

  static Future<List<SharedList>> _mapLists(List<dynamic> ids) async {
    List<SharedList> arr = [];
    for (String id in ids) {
      var list = await getSharedListById(id);
      if (list != null) arr.add(list);
    }
    return arr;
  }

  static Product _mapToProduct(QueryDocumentSnapshot<Map<String, dynamic>> e) =>
      Product.fromMap(e.id, e.data());
}
