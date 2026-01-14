
import 'package:sweater/features/profile/model/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoryAvatar {
  final String imageUrl;
  final String displayName;
  final String avatarId;
  final String ownerId;
  final VisibilityStatus visibilityStatus;

  StoryAvatar({
    required this.imageUrl,
    required this.displayName,
    required this.avatarId,
    required this.ownerId,
    required this.visibilityStatus,

  });

  factory StoryAvatar.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return StoryAvatar(
      imageUrl: doc['imageUrl'] as String? ?? '',
      displayName: doc['displayName'] as String? ?? '',
      avatarId: doc['avatarId'] as String? ?? '',
      ownerId: doc['ownerId'] as String? ?? '',
      visibilityStatus: doc['visibilityStatus'] is String
        ? VisibilityStatus.values.firstWhere(
            (e) => e.name == doc['visibilityStatus'],
            orElse: () => VisibilityStatus.shareFollowers,
          )
        : VisibilityStatus.shareFollowers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'displayName': displayName,
      'avatarId': avatarId,
      'ownerId': ownerId,
      'visibilityStatus': visibilityStatus.name,
    };
  }
}