
import 'package:cloud_firestore/cloud_firestore.dart';

enum WorkoutStatus {idle, active, paused, completed, canceled}

class Workout {
  final String workoutid;
  final String uid;
  final String sport;
  final WorkoutStatus status;
  final DateTime? startedAt;
  final DateTime? pausedAt;
  final DateTime? completedAt;
  final DateTime? updatedAt;

  Workout({
    required this.workoutid,
    required this.uid,
    required this.sport,
    required this.status,
    this.startedAt,
    this.pausedAt,
    this.completedAt,
    this.updatedAt,
  });

  factory Workout.fromMap(Map<String, dynamic> map, String id) {
    final statusName = map['status'] as String? ?? WorkoutStatus.idle.name;
    final status = WorkoutStatus.values.firstWhere(
      (e) => e.name == statusName,
      orElse: () => WorkoutStatus.idle,
    );
    return Workout(
      workoutid: id,
      uid: map['uid'] as String? ?? '',
      sport: map['sport'] as String? ?? '',
      status: status,
      startedAt: (map['startedAt'] as Timestamp?)?.toDate(),
      pausedAt: (map['pausedAt'] as Timestamp?)?.toDate(),
      completedAt: (map['completedAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'sport': sport,
      'status': status.name,
      'startedAt': startedAt != null ? Timestamp.fromDate(startedAt!) : null,
      'pausedAt': pausedAt != null ? Timestamp.fromDate(pausedAt!) : null,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}