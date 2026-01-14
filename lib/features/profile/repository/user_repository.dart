import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweater/features/profile/model/user_profile.dart';

class UserRepository {

  final FirebaseFirestore _db;
  UserRepository(this._db);

  Future<void> saveUser(UserProfile user) async {
    await _db.collection('users').doc(user.uid).set(
      user.toMap(),
      SetOptions(merge: true)
    );
  }

  Future<UserProfile?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserProfile.fromDoc(doc);
  }

  Stream<UserProfile?> watchUser(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserProfile.fromDoc(doc);
    });
  }
}
