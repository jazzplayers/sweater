import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String email;
  final String displayName;
  final String? photoURL;
  final DateTime? createdAt;
  int postsCount;
  int followersCount;
  int followingsCount;

  UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoURL,
    this.createdAt,
    this.postsCount = 0,
    this.followersCount = 0,
    this.followingsCount = 0,
  });

  /// 이 부분은 Firebase에서 가져온 데이터를 Dart객체로 변환하거나,
  ///  반대로 객체를 Firestore에 저장할 수 있게 변환하는 코드이다.
  factory UserProfile.fromMap(Map<String, dynamic> map, String uid) => UserProfile(
    uid: uid,
    email: map['email'],
    displayName: map['displayName'] ?? '',
    photoURL: map['photoURL'],
    createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    postsCount: map['postsCount'] ?? 0,
    followersCount: map['followersCount'] ?? 0,
    followingsCount: map['followingsCount'] ?? 0,
  );

  Map<String, dynamic> toMap() => {
    'email': email,
    'displayName': displayName,
    'photoURL': photoURL,
    'createdAt': createdAt,
    'postsCount': postsCount,
    'followersCount': followersCount,
    'followingsCount': followingsCount,
  };
}