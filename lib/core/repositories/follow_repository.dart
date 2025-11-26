import 'package:cloud_firestore/cloud_firestore.dart';

///팔로우, 팔로잉 버튼 관리

class FollowRepository {
  final FirebaseFirestore _db;
  FollowRepository(this._db);

  Future<bool> isFollowing({required String me, required String target}) async {
    final doc =
        await _db
            .collection('users')
            .doc(me)
            .collection('following')
            .doc(target)
            .get();
    return doc.exists;
  }

  Future<void> toggleFollow({
    required String me,
    required String target,
  }) async {
    final meFollowingRef = _db
        .collection('users')
        .doc(me)
        .collection('following')
        .doc(target);

    final targetFollowersRef = _db
        .collection('users')
        .doc(target)
        .collection('followers')
        .doc(me);

    final meDoc = _db.collection('users').doc(me);
    final targetDoc = _db.collection('users').doc(target);

    await _db.runTransaction((tx) async {
      final meFollowingSnap = await tx.get(meFollowingRef);

      if (meFollowingSnap.exists) {
        // UNFOLLOW
        tx.delete(meFollowingRef);
        tx.delete(targetFollowersRef);
        tx.update(meDoc, {'followingCount': FieldValue.increment(-1)});
        tx.update(targetDoc, {'followersCount': FieldValue.increment(-1)});
      } else {
        // FOLLOW
        tx.set(meFollowingRef, {
          'uid': target,
          'createdAt': FieldValue.serverTimestamp(),
        });
        tx.set(targetFollowersRef, {
          'uid': me,
          'createdAt': FieldValue.serverTimestamp(),
        });
        tx.update(meDoc, {'followingCount': FieldValue.increment(1)});
        tx.update(targetDoc, {'followersCount': FieldValue.increment(1)});
      }
    });
  }
}
