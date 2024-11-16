import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final String userClass;
  final String gender;
  final DateTime createdAt;
  final List<String> recentTranslations;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.userClass,
    required this.gender,
    required this.createdAt,
    this.recentTranslations = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'userClass': userClass,
      'gender': gender,
      'createdAt': createdAt,
      'recentTranslations': recentTranslations,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      userClass: map['userClass'] ?? '',
      gender: map['gender'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      recentTranslations: List<String>.from(map['recentTranslations'] ?? []),
    );
  }

  static Future<bool> isUsernameAvailable(String username) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    return querySnapshot.docs.isEmpty;
  }
}
