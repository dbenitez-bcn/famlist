import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famlist/list.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/product.dart';

class ListsService {
  final FirebaseAnalytics _analytics;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ListsService(this._analytics, this._firestore, this._auth);

  Future<SharedList> addList(String title) async {
    _analytics.logEvent(name: "list_created"); // TODO: Move to app state
    DocumentReference newList = await _firestore.collection("lists").add({
      "title": title,
      "created_at": FieldValue.serverTimestamp(),
    });
    return await addSharedList(newList.id);
  }

  Future<void> updateList(SharedList list) async {
    _analytics.logEvent(name: "list_updated"); // TODO: Move to app state
    await _firestore
        .collection("lists")
        .doc(list.id)
        .update({"title": list.title});
  }

  Future<SharedList> addSharedList(String listId) async {
    await _firestore
        .collection("shared_lists")
        .doc(_auth.currentUser!.uid)
        .set(
      {
        "lists": FieldValue.arrayUnion([listId])
      },
      SetOptions(merge: true),
    );
    return (await getSharedListById(listId))!;
  }

  Stream<List<SharedList>> getSharedLists() {
    return _firestore
        .collection("shared_lists")
        .doc(_auth.currentUser!.uid)
        .snapshots()
        .map(_getLists)
        .asyncMap(_mapLists);
  }

  Future<SharedList?> getFirstSharedList() async {
    var foo = await _firestore
        .collection("shared_lists")
        .doc(_auth.currentUser!.uid)
        .get();
    List<dynamic> ids = foo["lists"];
    if (ids.isNotEmpty) {
      return await getSharedListById(ids[0]);
    }
    return null;
  }

  Future<void> removeSharedList(String listId) async {
    _analytics.logEvent(name: "list_removed"); // TODO: Move to app state
    await _firestore
        .collection("shared_lists")
        .doc(_auth.currentUser!.uid)
        .set(
      {
        "lists": FieldValue.arrayRemove([listId])
      },
      SetOptions(merge: true),
    );
  }

  Future<SharedList?> getSharedListById(String id) async {
    DocumentSnapshot<Map<String, dynamic>> listDocument =
    await _firestore.collection("lists").doc(id).get();

    if (listDocument.exists) {
      return SharedList(listDocument.id, listDocument.data()!["title"]);
    }
    return null;
  }

  addProduct(String listId, String title, String? description) {
    _analytics.logEvent(name: "product_added"); // TODO: Move to app state
    _firestore.collection("lists/$listId/products").add({
      "title": title,
      "quantity": 1,
      "description": description,
      "created_at": FieldValue.serverTimestamp(),
    });
  }

  void increaseQuantity(String listId, Product product) async {
    await _firestore.doc("lists/$listId/products/${product.id}").update({
      "quantity": product.quantity + 1,
    });
  }

  void removeProduct(String listId, String productId) {
    _analytics.logEvent(name: "product_deleted"); // TODO: Move to app state
    _firestore.collection("lists/$listId/products").doc(productId).delete();
  }

  void updateProduct(String listId, Product product) async {
    _analytics.logEvent(name: "product_updated"); // TODO: Move to app state
    await _firestore.doc("lists/$listId/products/${product.id}").update({
      "title": product.title,
      "description": product.description,
      "quantity": product.quantity,
    });
  }

  Stream<List<Product>> getProducts(String listId) {
    return _firestore
        .collection("lists/$listId/products")
        .snapshots()
        .map((event) => event.docs.map(_mapToProduct).toList());
  }

  List<dynamic> _getLists(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      return document.data()!["lists"];
    }
    return [];
  }

  Future<List<SharedList>> _mapLists(List<dynamic> ids) async {
    List<SharedList> arr = [];
    for (String id in ids) {
      var list = await getSharedListById(id);
      if (list != null) arr.add(list);
    }
    return arr;
  }

  Product _mapToProduct(QueryDocumentSnapshot<Map<String, dynamic>> e) =>
      Product.fromMap(e.id, e.data());
}
