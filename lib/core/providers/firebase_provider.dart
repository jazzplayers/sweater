import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);
final storageProvider = Provider((ref) => FirebaseStorage.instance);

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.authStateChanges();
});
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).currentUser;
});


/// provider란 
/// riverpod에서 객체나 값을 전역적으로 제공하고 공유하는 도구이다.
/// 즉, 이 Firebase 인스턴스를 앱 어디에서나 꺼내 쓸 수 있게 하자 라는 뜻.
/// 
/// firebaseAuthProvider, FirebaseAuth.instance : 로그인, 회원가입, 인증 관련 기능
/// firestoreProvider , FIrebaseFirestore.instance : cloud Firestore DB 접근
/// storageProvidewr, FirebaseFirestore.instance : Firebvase Storage(이미지, 파일 업로드 등)
/// 
/// 
/// ***Firebase 인스턴스는 앱 전역에서 자주 사용된다.
/// 하지만 매번 FirebaseFirestore.instance.collection('users').get();으로 쓰면 지저분해진다.
/// 
/// 그래서 Riverpod Provider로 등록해두면, 다른 위젯이나 서비스에서 깔끔하고 안전하게 접근할 수 있따.
/// 
/// 
/// 이렇게 쓴다.
/// final firestore = ref.watch(firestoreProvider);
/// final auth = ref.watch(firebaseAuthProvider); 
/// 
/// final userRepositoryProvider = Provider((ref) {
/// final firestore = ref.watch(firestoreProvider);
/// return UserRepository(firestore);
/// });