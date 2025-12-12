import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweater/features/profile/model/avatar.dart';

class AvatarRepository {
  final FirebaseFirestore _db;
  AvatarRepository(this._db);

  // ─────────────────────────────────────────────
  // 1) users/{userId}/avatars 콜렉션 참고 헬퍼
  // ─────────────────────────────────────────────
  CollectionReference<Map<String, dynamic>> _userAvatarsCol(String userId) {
    return _db.collection('users').doc(userId).collection('avatars');
  }

  // users/{userId}/avatars/{avatarId} 문서 reference
  DocumentReference<Map<String, dynamic>> _doc(
    String userId,
    String avatarId,
  ) {
    return _userAvatarsCol(userId).doc(avatarId);
  }

  // ─────────────────────────────────────────────
  // 2) 전역(전체 유저) 아바타 피드용 query
  //    → collectionGroup 사용
  // ─────────────────────────────────────────────

  // collectionGroup 쿼리
  // collectionGroup은 Firestore에서 특정 이름을 가진 모든 subcollection을 한 번에 조회하는 기능
  Query<Map<String, dynamic>> get globalAvatarQuery =>
      _db.collectionGroup('avatars').orderBy(
            'completedAt',
            descending: true,
          );


  // 전체 유저 아바타 스트림 (홈 피드 같은 곳에서 사용)
  Stream<List<Avatar>> globalAvatarsStream() {
    return globalAvatarQuery.snapshots().map(
      (snap) => snap.docs
          .map(
            (doc) => Avatar.fromMap(
              doc.data(),
              doc.id, // 여기서는 doc.id를 avatarId로 사용
            ),
          )
          .toList(),
    );
  }

  // ─────────────────────────────────────────────
  // 3) 특정 유저의 avatars (내 프로필, 유저 프로필에서 사용)
  // ─────────────────────────────────────────────
  Stream<List<Avatar>> userAvatarsStream(String userId) {
    return _userAvatarsCol(userId)
        .orderBy('completedAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (doc) => Avatar.fromMap(
                  doc.data(),
                  doc.id, // avatarId
                ),
              )
              .toList(),
        );
  }

  // ─────────────────────────────────────────────
  // 4) 단일 아바타 읽기
  // ─────────────────────────────────────────────
  Future<Avatar?> getAvatar({
    required String userId,
    required String avatarId,
  }) async {
    final docSnap = await _doc(userId, avatarId).get();
    if (!docSnap.exists) return null;
    return Avatar.fromMap(docSnap.data()!, docSnap.id);
  }

  // ─────────────────────────────────────────────
  // 5) 아바타 생성 (avatarId 자동 생성)
  //    - Avatar.uid 를 avatarId(문서 id)로 쓰는 구조라면
  //      아래 setAvatarWithFixedId 처럼 써도 되고,
  //    - 자동 id를 쓰고 싶으면 addAvatar() 사용
  // ─────────────────────────────────────────────

  /// avatarId를 직접 정해서 쓰고 싶을 때 사용
  /// (Avatar.uid 를 avatarId로 쓴다는 가정)
  Future<void> setAvatar({
    required String userId,
    required Avatar avatar,
  }) async {
    await _userAvatarsCol(userId)
        .doc(avatar.uid) // 여기서 avatar.uid는 avatarId 역할
        .set(avatar.toMap());
  }

  /// Firestore가 avatarId를 자동으로 만들어주게 하고 싶을 때
  Future<String> addAvatar({
    required String userId,
    required Avatar avatar,
  }) async {
    final docRef = await _userAvatarsCol(userId).add(avatar.toMap());
    return docRef.id; // 생성된 avatarId 리턴
  }

  // ─────────────────────────────────────────────
  // 6) 단일 아바타 실시간 감시
  // ─────────────────────────────────────────────
  Stream<Avatar?> watchAvatar({
    required String userId,
    required String avatarId,
  }) {
    return _doc(userId, avatarId).snapshots().map((docSnap) {
      if (!docSnap.exists) return null;
      return Avatar.fromMap(docSnap.data()!, docSnap.id);
    });
  }

  // ─────────────────────────────────────────────
  // 7) 삭제 / 업데이트
  // ─────────────────────────────────────────────
  Future<void> deleteAvatar({
    required String userId,
    required String avatarId,
  }) async {
    await _doc(userId, avatarId).delete();
  }

  Future<void> updateAvatar({
    required String userId,
    required String avatarId,
    required Avatar avatar,
  }) async {
    await _doc(userId, avatarId).update(avatar.toMap());
  }
}
