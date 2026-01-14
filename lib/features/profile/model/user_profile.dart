import 'package:cloud_firestore/cloud_firestore.dart';

enum SweateringStatus { none, sweatering, completed }
enum VisibilityStatus { shareFollowers, private }

class UserProfile {
  final String uid;
  final String email;
  final String displayName;
  final String? photoURL;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final SweateringStatus sweateringStatus;
  final VisibilityStatus visibilityStatus;
  int postsCount;
  int followersCount;
  int followingsCount;

  UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoURL,
    this.createdAt,
    this.updatedAt,
    this.sweateringStatus = SweateringStatus.none,
    this.visibilityStatus = VisibilityStatus.shareFollowers,
    this.postsCount = 0,
    this.followersCount = 0,
    this.followingsCount = 0,
  });

   UserProfile copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    DateTime? createdAt,
    DateTime? updatedAt,
    SweateringStatus? sweateringStatus,
    VisibilityStatus? visibilityStatus,
    int? postsCount,
    int? followersCount,
    int? followingsCount,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sweateringStatus: sweateringStatus ?? this.sweateringStatus,
      visibilityStatus: visibilityStatus ?? this.visibilityStatus,
      postsCount: postsCount ?? this.postsCount,
      followersCount: followersCount ?? this.followersCount,
      followingsCount: followingsCount ?? this.followingsCount,
    );
  }

  /// 이 부분은 Firebase에서 가져온 데이터를 Dart객체로 변환하거나,
  ///  반대로 객체를 Firestore에 저장할 수 있게 변환하는 코드이다.
  factory UserProfile.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) throw Exception('Document data is null');
    return UserProfile(
    uid: doc.id,
    email: (data['email'] is String) ? data['email'] as String : '',
    displayName: (data['displayName'] is String) ? data['displayName'] as String : '',
    photoURL: (data['photoURL'] is String) ? data['photoURL'] as String : null,
    createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    sweateringStatus: data['sweateringStatus'] is String
        ? SweateringStatus.values.firstWhere(
            (e) => e.name == data['sweateringStatus'],
            orElse: () => SweateringStatus.none,
          )
        : SweateringStatus.none,
    visibilityStatus: data['visibilityStatus'] is String
        ? VisibilityStatus.values.firstWhere(
            (e) => e.name == data['visibilityStatus'],
            orElse: () => VisibilityStatus.shareFollowers,
          )
        : VisibilityStatus.shareFollowers,
    postsCount: data['postsCount'] is int ? data['postsCount'] : 0,
    followersCount: data['followersCount'] is int ? data['followersCount'] : 0,
    followingsCount: data['followingsCount'] is int ? data['followingsCount'] : 0,
  );
  }

  Map<String, dynamic> toMap() => {
    'email': email,
    'displayName': displayName,
    'photoURL': photoURL,
    'updatedAt': FieldValue.serverTimestamp(),
    'sweateringStatus': sweateringStatus.name,
    'visibilityStatus': visibilityStatus.name,
    'postsCount': postsCount,
    'followersCount': followersCount,
    'followingsCount': followingsCount,
  };
}
