import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  late final String? id;
  late final String? title;
  late final String? description;
  late final String? estimateTime;
  late final String? completeTime;
  late final String? timeStamp;
  late final String? state;
  late final String? employee;
  late final String? project;

  TaskModel(
      {this.id,
      this.title,
      this.description,
      this.estimateTime,
      this.completeTime,
      this.timeStamp,
      this.state,
      this.employee,
      this.project});

  factory TaskModel.fromMap(map) {
    return TaskModel(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        estimateTime: map['estimateTime'],
        completeTime: map['completeTime'],
        timeStamp: map['timeStamp'],
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
      'timeStamp': FieldValue.serverTimestamp(),
      'state': state,
      'employee': employee,
      'project': project,
    };
  }

  @override
  String toString() {
    return '$title $description $estimateTime $completeTime';
  }
}
