import 'package:cloud_firestore/cloud_firestore.dart';

class FeedItemModel {
  late final String? id;
  late final String? username;
  late final String? userId;
  late final String? userProgileImage;
  late final String? title;
  late final String? type;
  late final String? employeeId;
  late final DateTime? createdAt;
  late final DateTime? updatedAt;

  FeedItemModel({
    this.id,
    this.username,
    this.userId,
    this.userProgileImage,
    this.title,
    this.type,
    this.employeeId,
    this.createdAt,
    this.updatedAt,
  });

  factory FeedItemModel.fromMap(map) {
    return FeedItemModel(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      userId: map['userId'] ?? '',
      userProgileImage: map['userProgileImage'] ?? '',
      title: map['title'] ?? '',
      type: map['type'] ?? '',
      employeeId: map['employeeId'] ?? '',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'userId': userId,
      'userProgileImage': userProgileImage,
      'title': title,
      'type': type,
      'employeeId': employeeId,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': updatedAt,
    };
  }
}
