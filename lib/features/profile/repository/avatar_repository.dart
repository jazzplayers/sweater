import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sweater/features/profile/model/avatar.dart';
import 'package:sweater/models/user_profile.dart';
import 'package:sweater/models/sweateringstatus.dart';

class AvatarRepository {
  final FirebaseFirestore _db;
  AvatarRepository(this._db);

  DocumentReference<Map<String, dynamic>> avatarDocRef({
    required String uid,
  }) {
    return _db.collection('users').doc(uid).collection('avatars').doc('profileAvatar');
  }

  Future<Avatar?> getUserAvatar(String uid) async {
    final doc = await avatarDocRef(uid: uid).get();
    if (doc.exists) {
      return Avatar.fromMap(doc.data()!);
    }
    return null;
  }

  Future<void> setUserAvatar(String uid, Avatar avatar) async {
    await avatarDocRef(uid: uid).set(avatar.toMap());
  }

  Future<void> updateUserAvatar(String uid, Map<String, dynamic> data) async {
    await avatarDocRef(uid: uid).update(data);
  }

  Future<void> deleteUserAvatar(String uid) async {
    await avatarDocRef(uid: uid).delete();
  }

  Future<List<Avatar>> getAllAvatars() async {
    final querySnapshot = await _db.collectionGroup('avatars').get();
    return querySnapshot.docs
        .map((doc) => Avatar.fromMap(doc.data()))
        .toList();
  }

  Future<List<Avatar>> getUserAvatars(String uid) async {
    final querySnapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('avatars')
        .get();
    return querySnapshot.docs
        .map((doc) => Avatar.fromMap(doc.data()))
        .toList();
  }

  Stream<List<Avatar>> globalAvatarsStream() {
    return _db.collectionGroup('avatars').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Avatar.fromMap(doc.data()))
          .toList();
    });
  }

}

class AvatarSweateringNotifier extends StateNotifier<Sweateringstatus> {
  AvatarSweateringNotifier() : super(Sweateringstatus.none);                                                          

  void setStatus(Sweateringstatus status) {
    state = status;
  }
}


final avatarSweateringProvider = StateNotifierProvider.autoDispose<AvatarSweateringNotifier, Sweateringstatus>((ref) {
  return AvatarSweateringNotifier();
});                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     