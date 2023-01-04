import 'package:cloud_firestore/cloud_firestore.dart';

Stream<DocumentSnapshot<Map<String, dynamic>>> getData(
    String id, String index) {
  var collection = FirebaseFirestore.instance.collection(index);
  var docSnapshot = collection.doc(id).snapshots();
  return docSnapshot;
}
