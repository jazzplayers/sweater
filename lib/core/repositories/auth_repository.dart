import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweater/models/user_profile.dart';
import 'dart:async';

/// FirebaseAuth/Firestore 호출을 한 곳으로 모음(UI/Controller 가 firebase에 직접 의존 하지 않게)
/// 회원 가입 시 Auth 프로필(displayName) 업데이트 + Firebase에 users 문서 생성.

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  AuthRepository(this._auth, this._db);

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserCredential> signIn(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String displayName,
    String? photoURL,
  }) async {
    // 1) Auth 계정 생성
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // 2) 표시이름 업데이트(선택)
    if (cred.user != null) {
      await cred.user!.updateDisplayName(displayName);
      // await cred.user!.reload(); // 필요 시
    }


    // 3) Firestore 프로필 문서 생성 (모델 → toMap 사용)
    final profile = UserProfile(
      uid: cred.user!.uid,
      email: email,
      displayName: displayName,
      photoURL: cred.user?.photoURL,
    );

    try {
      final data = profile.toMap();
      data['createdAt'] = FieldValue.serverTimestamp();
      data['updatedAt'] = FieldValue.serverTimestamp();

      /// 위랑 같은 거임.
      /// final data = profile.toMap()
      /// ..['createdAt'] = FieldValue.serverTimestamp()
      /// ..['updatedAt'] = FieldValue.serverTimestamp();

      await _db.collection('users').doc(profile.uid).set(data);
    } catch (e) {
      // Firestore 저장 실패 시, 방금 만든 Auth 계정을 지울지 결정(선택사항)
      try {
        await cred.user?.delete();
      } catch (_) {}
      rethrow;
    }

    return cred;
  }

  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  Future<void> signOut() => _auth.signOut();
}