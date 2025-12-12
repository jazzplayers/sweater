import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String postId;
  final String ownerId;
  final String ownerName;
  final String? ownerPhotoURL;
  final List<String> imageURLs;
  final String? text;
  final int likeCount;
  final int commentCount;
  final DateTime? createdAt;
  final bool isLiked;

  Post({
    required this.postId,
    required this.ownerId,
    required this.ownerName,
    this.ownerPhotoURL,
    required this.imageURLs,
    this.text,
    required this.likeCount,
    required this.commentCount,
    this.createdAt,
    this.isLiked = false,
  });

  /// Firebase에서 문서(doc) 를 읽어올 때,
  /// 그 데이터를 Dart 객체로 반환하는 "팩토리 생성자(factory constructory)"
  /// Firestore는 데이터를 항상 Map<String, dynamic> 형태로 주기 때문에
  /// data()로 받아온 Map을 객체로 가공하는 것이다.

  factory Post.fromMap(Map<String, dynamic> map, String postId) {
    return Post(
      postId: postId,
      ownerId: map['ownerId'],
      ownerName: map['ownerName'] ?? '',
      ownerPhotoURL: map['ownerPhotoURL'],
      imageURLs: (map['imageURLs'] as List).map((e) => e as String).toList(),
      text: map['text'],
      likeCount: (map['likeCount'] ?? 0) as int,
      commentCount: (map['commentCount'] ?? 0) as int,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      isLiked: map['isLiked'] ?? false,
    );
  }
}
