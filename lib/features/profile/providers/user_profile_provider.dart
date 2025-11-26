import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sweater/core/providers/firebase_provider.dart';
import 'package:sweater/core/repositories/follow_repository.dart';
import 'package:sweater/core/repositories/user_repository.dart';
import 'package:sweater/models/user_profile.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final db = ref.watch(firestoreProvider);
  return UserRepository(db);
});

final userProfileProvider = StreamProvider.family<UserProfile?, String>((
  ref,
  uid,
) {
  final repo = ref.watch(userRepositoryProvider);
  return repo.watchUser(uid);
});

final currentUserProvider = Provider<User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.currentUser;
});

final userFutureProvider = FutureProvider.family<UserProfile?, String>((
  ref,
  uid,
) {
  final repo = ref.watch(userRepositoryProvider);
  return repo.getUser(uid);
});
