import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sweater/core/providers/firebase_provider.dart';
import 'package:sweater/core/repositories/follow_repository.dart';
import 'package:sweater/models/user_profile.dart';

final followRepositoryProvider = Provider<FollowRepository>((ref) {
  final db = ref.watch(firestoreProvider);
  return FollowRepository(db);
});

final followersProvider = FutureProvider.family<List<UserProfile>, String>((
  ref,
  uid,
) async {
  final db = FirebaseFirestore.instance;
  final snapshot =
      await db.collection('users').doc(uid).collection('followers').get();

  return snapshot.docs.map((doc) => UserProfile.fromMap(doc.data(), doc.id)).toList();
});

final followingsProvider = FutureProvider.family<List<UserProfile>, String>((
  ref,
  uid,
) async {
  final db = FirebaseFirestore.instance;
  final snapshot =
      await db.collection('users').doc(uid).collection('followings').get();

  return snapshot.docs.map((doc) => UserProfile.fromMap(doc.data(), doc.id)).toList();
});
