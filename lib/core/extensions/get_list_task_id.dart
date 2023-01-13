import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

getListTaskId() async {
  List? filterState = [];
  final result = await FirebaseFirestore.instance
      .collection('tasks')
      .where('state', isEqualTo: 'To Do')
      .get()
      .then(
    (value) {
      value.docs.forEach(
        (element) {
          filterState.add(element.id);
        },
      );
    },
  ).catchError((e) => print('error fetching data: $e'));
}
