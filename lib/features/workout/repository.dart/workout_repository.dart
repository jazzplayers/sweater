import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweater/features/workout/models/workout.dart';

class WorkoutRepository {
  final _db = FirebaseFirestore.instance;

  Stream<Workout> getWorkoutStream(String workoutid) {
    return _db.collection('workouts').doc(workoutid).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data != null) {
        return Workout.fromMap(data, snapshot.id);
      } else {
        throw Exception('Workout not found');
      }
    });
  }
  
  Future<void> createWorkout(Workout workout) async {
    await _db.collection('workouts').doc(workout.workoutid).set(workout.toMap());
  }
  Future<void> updateWorkoutStatus(String workoutid, WorkoutStatus status) async {
    await _db.collection('workouts').doc(workoutid).set({
      'status': status.name,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}