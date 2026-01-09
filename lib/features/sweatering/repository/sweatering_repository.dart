import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweater/features/sweatering/model/sweateringstatus.dart';

class SweateringRepository {
  final _db = FirebaseFirestore.instance;

  Stream<Sweatering> getSweateringStatusStream(String uid) {
    return _db.collection('sweatering').doc(uid).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data != null) {
        return Sweatering.fromMap(data);
      } else {
        return Sweatering(status: Sweateringstatus.none);
      }
    });
  }

  Future<void> updateSweateringStatus(String uid, Sweateringstatus status) async {
    await _db.collection('sweatering').doc(uid).set({
      'sweateringstatus': status.name,
    }, SetOptions(merge: true));
  }

  Future<void> startSweatering(String uid) async {
    await _db.collection('sweatering').doc(uid).set({
      'sweateringstatus': Sweateringstatus.sweatering.name,
    }, SetOptions(merge: true));
  }

  Future<void> complete(String uid) async {
    await _db.collection('sweatering').doc(uid).set({
      'sweateringstatus': Sweateringstatus.completed.name,
      'sweateringcompletedat': DateTime.now(),
    }, SetOptions(merge: true));
  }

}