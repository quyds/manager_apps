import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'expansion_tile_list.dart';

class ProjectList extends StatelessWidget {
  ProjectList();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('projects').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        //final int projectsCount = snapshot.data.documents.length;
        List<DocumentSnapshot> documents = snapshot.data!.docs;
        return ExpansionTileList(
          documents: documents,
        );
      },
    );
  }
}
