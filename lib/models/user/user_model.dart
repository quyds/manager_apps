import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? email;
  String? name;
  String? profileImage;
  String? phone;
  String? level;
  var timeStamp;

  UserModel({
    this.uid,
    this.email,
    this.name,
    this.profileImage,
    this.phone,
    this.level,
    this.timeStamp,
  });

  factory UserModel.fromMap(Map map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        name: map['name'],
        profileImage: map['profileImage'],
        phone: map['phone'],
        level: map['level'],
        timeStamp: map['timeStamp']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'profileImage': profileImage,
      'phone': phone,
      'level': level,
      'timeStamp': FieldValue.serverTimestamp(),
    };
  }
}
