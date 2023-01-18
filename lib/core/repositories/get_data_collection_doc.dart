import 'package:cloud_firestore/cloud_firestore.dart';

Stream<DocumentSnapshot<Map<String, dynamic>>> getDataDoc(
    String id, String index) {
  var collection = FirebaseFirestore.instance.collection(index);
  var docSnapshot = collection.doc(id).snapshots();
  return docSnapshot;
}

Stream<QuerySnapshot<Map<String, dynamic>>> getDataCollection(String index) {
  var collection = FirebaseFirestore.instance.collection(index).snapshots();
  return collection;
}

Stream<DocumentSnapshot<Map<String, dynamic>>> getDataDocs(
    String id, String index) {
  var collection = FirebaseFirestore.instance.collection(index);
  var docSnapshot = collection.doc(id).get().asStream();
  return docSnapshot;
}
