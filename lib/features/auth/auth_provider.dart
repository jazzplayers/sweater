import 'package:sweater/core/providers/firebase_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sweater/core/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final db = ref.watch(firestoreProvider);
  return AuthRepository(auth, db);
});
