import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweater/models/sweateringstatus.dart';
import 'package:flutter/material.dart';

class Avatar {
  final String uid;
  final String avatarId;
  final Sweateringstatus status;
  final String imageUrl;
  final DateTime completedAt;
  final bool isPublic;

  const Avatar({
    required this.uid,
    required this.avatarId,
    required this.status,
    required this.imageUrl,
    required this.completedAt,
    this.isPublic = false,
  });


  factory Avatar.fromMap(Map<String,dynamic> map, String uid) {
  return Avatar(
    uid: uid,
    avatarId: map['avatarId'] ?? '',
    completedAt: (map['completedAt'] as Timestamp?)?.toDate() ??
        DateTime.fromMillisecondsSinceEpoch(0), // 또는 DateTime.now()
    status: Sweateringstatus.values[(map['status'] ?? 0)],
    imageUrl: map['imageUrl'] ?? '',
    isPublic: map['isPublic'] ?? false,
  );
}

Map<String, dynamic> toMap() {
  return {
    'uid': uid,
    'avatarId': avatarId,
    'completedAt': Timestamp.fromDate(completedAt),
    'status': status.index,
    'imageUrl': imageUrl,
    'isPublic': isPublic, 
  };
}

Avatar copyWith({
  String? uid,
  String? avatarId,
  Sweateringstatus? status,
  String? imageUrl,
  DateTime? completedAt,
  bool? isPublic,
}) {
  return Avatar(
    uid: uid ?? this.uid,
    avatarId: avatarId ?? this.avatarId,
    status: status ?? this.status,
    imageUrl: imageUrl ?? this.imageUrl,
    completedAt: completedAt ?? this.completedAt,
    isPublic: isPublic ?? this.isPublic,
  );
  }
}
