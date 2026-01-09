import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweater/features/sweatering/model/sweateringstatus.dart';

class Avatar {
  final Sweateringstatus status;
  final String imageUrl;
  final DateTime completedAt;
  final bool isPublic;

  const Avatar({
    required this.status,
    required this.imageUrl,
    required this.completedAt,
    this.isPublic = false,
  });


  factory Avatar.fromMap(
    Map<String,dynamic> map, 
  ) {
      final rawImageUrl = map['imageUrl'];
      final rawisPublic = map['isPublic'];
  return Avatar(
    completedAt: (map['completedAt'] as Timestamp?)?.toDate() ??
        DateTime.fromMillisecondsSinceEpoch(0), // 또는 DateTime.now()
    status: Sweateringstatus.values.firstWhere(
      (e) => e.name == map['status'],
      orElse: () => Sweateringstatus.none,
    ),
    imageUrl: rawImageUrl is String ? rawImageUrl : '',
    isPublic: rawisPublic is bool ? rawisPublic : false,
  );
}

Map<String, dynamic> toMap() {
  return {
    'completedAt': Timestamp.fromDate(completedAt),
    'status': status.name,
    'imageUrl': imageUrl,
    'isPublic': isPublic, 
  };
}

Avatar copyWith({
  Sweateringstatus? status,
  String? imageUrl,
  DateTime? completedAt,
  bool? isPublic,
}) {
  return Avatar(
    status: status ?? this.status,
    imageUrl: imageUrl ?? this.imageUrl,
    completedAt: completedAt ?? this.completedAt,
    isPublic: isPublic ?? this.isPublic,
  );
  }
}
