import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  late final String? id;
  late final String? title;
  late final String? description;
  late final DateTime? createdAt;
  late final DateTime? updatedAt;
  late final List? taskArray;
  late final List? employeeArray;

  ProjectModel({
    this.id,
    this.title,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.taskArray,
    this.employeeArray,
  });

  factory ProjectModel.fromMap(map) {
    return ProjectModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
      taskArray: map['taskArray'] ?? [],
      employeeArray: map['employeeArray'] ?? [],
      // == null
      //     ? null
      //     : List<TaskModel>.from(
      //         map["taskArray"].map((x) => TaskModel.fromMap(x))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': updatedAt,
      'taskArray': taskArray == null
          ? null
          : List<dynamic>.from(taskArray!.map((x) => x.toMap())),
      'employeeArray': employeeArray == null
          ? null
          : List<dynamic>.from(employeeArray!.map((x) => x.toMap())),
    };
  }
}
