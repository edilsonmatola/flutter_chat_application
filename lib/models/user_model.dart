import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.dateTime,
  });

  factory UserModel.fromJson(DocumentSnapshot json) => UserModel(
        uid: json['uid'] as String,
        name: json['userName'] as String,
        email: json['email'] as String,
        imageUrl: json['image'] as String,
        dateTime: json['dateTime'] as Timestamp,
      );

  final String uid;
  final String name;
  final String email;
  final String imageUrl;
  final Timestamp dateTime;
}
