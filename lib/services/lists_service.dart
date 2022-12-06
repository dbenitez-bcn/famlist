import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListsService {
  static Future<void> addList(String title) async {
    if (FirebaseAuth.instance.currentUser != null) {
      DocumentReference newList =
          await FirebaseFirestore.instance.collection("lists").add({
        "title": title,
        "created_at": FieldValue.serverTimestamp(),
      });
      await FirebaseFirestore.instance
          .collection("shared_lists")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(
        {
          "lists": FieldValue.arrayUnion([newList.id])
        },
        SetOptions(merge: true),
      );
    }
  }
}
