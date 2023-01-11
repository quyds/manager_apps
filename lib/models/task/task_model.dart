import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/material/list_tile.dart';

import '../../core/extensions/date_format.dart';

class TaskModel {
  late final String? id;
  late final String? title;
  late final String? description;
  late final String? estimateTime;
  late final String? completeTime;
  late final DateTime? createdAt;
  late final DateTime? updatedAt;
  late final String? state;
  late final String? employee;
  late final String? project;

  TaskModel({
    this.id,
    this.title,
    this.description,
    this.estimateTime,
    this.completeTime,
    this.createdAt,
    this.updatedAt,
    this.state,
    this.employee,
    this.project,
  });

  factory TaskModel.fromMap(map) {
    return TaskModel(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        estimateTime: map['estimateTime'],
        completeTime: map['completeTime'],
        createdAt: (map['createdAt'] as Timestamp).toDate(),
        updatedAt: map['updatedAt'] != null
            ? (map['updatedAt'] as Timestamp).toDate()
            : map['updatedAt'],
        state: map['state'],
        employee: map['employee'],
        project: map['project']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'estimateTime': estimateTime,
      'completeTime': completeTime,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': updatedAt,
      'state': state,
      'employee': employee,
      'project': project,
    };
  }

  @override
  String toString() {
    return '$title $description $estimateTime $completeTime';
  }

  map(ListTile Function(dynamic e) param0) {}
}
