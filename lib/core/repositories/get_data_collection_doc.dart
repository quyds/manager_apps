import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manager_apps/models/project/project_model.dart';

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

Stream<List<ProjectModel>> getAllProjects() {
  var data = FirebaseFirestore.instance.collection("projects").snapshots().map(
      (snapshots) => snapshots.docs
          .map((doc) => ProjectModel.fromMap(doc.data()))
          .toList());

  return data;
}
