import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'projects_expansion_tile.dart';

class ExpansionTileList extends StatelessWidget {
  final List<DocumentSnapshot> documents;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  ExpansionTileList({required this.documents});

  List<Widget> _getChildren() {
    List<Widget> children = [];
    documents.forEach((doc) {
      children.add(
        ProjectsExpansionTile(
          name: doc['taskArray'],
          projectKey: doc.id,
          firestore: firestore,
        ),
      );
    });
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _getChildren(),
    );
  }
}
