import 'package:cloud_firestore/cloud_firestore.dart';

 enum Sweateringstatus{none, sweatering, completed,}

 class Sweatering {
  final Sweateringstatus status;
  final DateTime? completedAt;
  final DateTime? updatedAt;

  Sweatering({
    required this.status,
    this.completedAt,
    this.updatedAt,
  });

factory Sweatering.fromMap(Map<String, dynamic> map) {
  final status = map['sweateringstatus'] as String? ?? 'none';
  final sweateringstatus = Sweateringstatus.values.firstWhere(
    (e) => e.name == status,
    orElse: () => Sweateringstatus.none,
  );
  
final parsedCompletedAt = (map['sweateringcompletedat'] as Timestamp?)?.toDate();
final parsedUpdatedAt = (map['sweateringupdatedat'] as Timestamp?)?.toDate();

  return Sweatering(
    status: sweateringstatus,
    completedAt: parsedCompletedAt,
    updatedAt: parsedUpdatedAt,
  );
}

  Map<String, dynamic> toMap() {
    return {
      'sweateringstatus': status.name,
      'sweateringcompletedat': completedAt == null 
      ? null
      : Timestamp.fromDate(completedAt!),
      'sweateringupdatedat': updatedAt == null
      ? null
      : Timestamp.fromDate(updatedAt!),
    };
  }

  Sweatering copyWith({
    Sweateringstatus? status,
    DateTime? completedAt,
    DateTime? updatedAt,
  }) {
    return Sweatering(
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
 }
