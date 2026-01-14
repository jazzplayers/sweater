import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweater/features/sweatering/model/sweateringstatus.dart';


class StoryAvatar {
  final String id;
  final String ownerId;
  final String imageUrl;
  final DateTime completedAt;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final Sweateringstatus status;

  const StoryAvatar({
    required this.id,
    required this.ownerId,
    required this.imageUrl,
    required this.completedAt,
    this.updatedAt,
    this.createdAt,
    this.status = Sweateringstatus.none,
  });

  factory StoryAvatar.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data();
  if (data == null) throw Exception('Document data is null');
  return StoryAvatar(
    id: doc.id,
    ownerId: data['ownerId'] as String? ?? '',
    imageUrl: data['imageUrl'] as String? ?? '',
    completedAt: (data['completedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    status: data['status'] is String
        ? Sweateringstatus.values.firstWhere(
            (e) => e.toString() == 'Sweateringstatus.${data['status']}',
            orElse: () => Sweateringstatus.none,
          )
        : Sweateringstatus.none,
  );
}

  factory StoryAvatar.fromMap(Map<String, dynamic> map) {
    final rawImageUrl = map['imageUrl'];
    final rawStatus = map['status'];
    final rawVisibility = map['visibility'];

    return StoryAvatar(
      id: map['id'] as String? ?? '',
      ownerId: map['ownerId'] as String? ?? '',
      completedAt: (map['completedAt'] as Timestamp?)?.toDate() ??
          DateTime.now(),
    updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    imageUrl: rawImageUrl is String ? rawImageUrl : '',
    status: rawStatus is String
        ? Sweateringstatus.values.firstWhere(
            (e) => e.toString() == 'Sweateringstatus.$rawStatus',
            orElse: () => Sweateringstatus.none,
          )
        : Sweateringstatus.none,
  );
}

Map<String, dynamic> toMap() {
  return {
    'ownerId': ownerId,
    'completedAt': Timestamp.fromDate(completedAt),
    if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
    if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
    'imageUrl': imageUrl,
    'status': status.toString().split('.').last,
  };
}

StoryAvatar copyWith({
  String? id,
  String? ownerId,
  String? imageUrl,
  DateTime? completedAt,
  DateTime? updatedAt,
  DateTime? createdAt,
  Sweateringstatus? status,
}) {
  return StoryAvatar(
    id: id ?? this.id,
    ownerId: ownerId ?? this.ownerId,
    imageUrl: imageUrl ?? this.imageUrl,
    completedAt: completedAt ?? this.completedAt,
    updatedAt: updatedAt ?? this.updatedAt,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
  );
}
}

