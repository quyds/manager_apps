import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProjectsExpansionTile extends StatelessWidget {
  ProjectsExpansionTile(
      {required this.projectKey, required this.name, required this.firestore});

  final String projectKey;
  final String name;
  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    PageStorageKey _projectKey = PageStorageKey('$projectKey');

    return ExpansionTile(
      key: _projectKey,
      title: Text(
        name,
        style: TextStyle(fontSize: 28.0),
      ),
      children: <Widget>[
        StreamBuilder(
            stream: firestore
                .collection('projects')
                .doc(projectKey)
                .collection('tasks')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return const Text('Loading...');
              //final int surveysCount = snapshot.data.documents.length;
              List<DocumentSnapshot> documents = snapshot.data!.docs;

              List<Widget> surveysList = [];
              documents.forEach((doc) {
                PageStorageKey _surveyKey = new PageStorageKey('${doc.id}');

                surveysList.add(ListTile(
                  key: _surveyKey,
                  title: Text(doc['taskArray']),
                ));
              });
              print(
                firestore.collection('projects').doc(projectKey),
              );
              return Column(children: surveysList);
            })
      ],
    );
  }
}
