import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famlist/list.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/product.dart';

class ListsService {
  static Future<String> addList(String title) async {
    if (FirebaseAuth.instance.currentUser != null) {
      DocumentReference newList =
          await FirebaseFirestore.instance.collection("lists").add({
        "title": title,
        "created_at": FieldValue.serverTimestamp(),
      });
      await addSharedList(newList.id);
      return newList.id;
    }
    return "";
  }

  static Future<void> addSharedList(String listId) async {
    await FirebaseFirestore.instance
        .collection("shared_lists")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(
      {
        "lists": FieldValue.arrayUnion([listId])
      },
      SetOptions(merge: true),
    );
  }

  static Future<String> getListTitle(String listId) async {
    var list =
        await FirebaseFirestore.instance.collection("lists").doc(listId).get();
    return list.data()!["title"];
  }

  static Future<SharedList> getSharedListById(String id) async {
    DocumentSnapshot<Map<String, dynamic>> listDocument =
        await FirebaseFirestore.instance.collection("lists").doc(id).get();

    return SharedList(listDocument.id, listDocument.data()!["title"]);
  }

  static addProduct(String listId, String title, String? description) {
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
    FirebaseFirestore.instance
        .collection("lists/$listId/products")
        .doc(productId)
        .delete();
  }

  static void updateProduct(String listId, Product product) async {
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

  static Product _mapToProduct(QueryDocumentSnapshot<Map<String, dynamic>> e) =>
      Product.fromMap(e.id, e.data());
}
