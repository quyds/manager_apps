import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manager_apps/models/task/task_model.dart';

class ProjectModel {
  late final String? id;
  late final String? title;
  late final String? description;
  late final DateTime? createdAt;
  late final DateTime? updatedAt;
  late List? taskArray;

  ProjectModel({
    this.id,
    this.title,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.taskArray,
  });

  factory ProjectModel.fromMap(map) {
    return ProjectModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : map['updatedAt'],
      taskArray: map['taskArray'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': updatedAt,
      'taskArray': taskArray,
    };
  }
}
