import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sweater/core/providers/firebase_provider.dart';
import 'package:sweater/features/profile/model/avatar.dart';
import 'package:sweater/features/profile/repository/avatar_repository.dart';
import 'package:sweater/features/sweatering/model/sweateringstatus.dart';

final avatarRepositoryProvider = Provider<AvatarRepository>((ref) {
  final _db = ref.watch(firestoreProvider);
  return AvatarRepository(_db);
});

final avatarsStreamProvider = StreamProvider<List<Avatar>>((ref) {
  final avatarRepository = ref.watch(avatarRepositoryProvider);
  return avatarRepository.globalAvatarsStream();
});

final userAvatarStreamProvider = StreamProvider.family<List<Avatar>, String>((ref, uid) {
  final avatarRepository = ref.watch(avatarRepositoryProvider);
  return avatarRepository.getUserAvatars(uid).asStream();
});

final sweateringstatusStreamProvider = StreamProvider.family<Sweateringstatus, String>((ref, uid) {
  final repo = ref.watch(avatarRepositoryProvider);
  return repo.watchAvatarDoc(uid).map((data) {
    final statusString = data['sweateringstatus'] as String? ?? 'none';
    return Sweateringstatus.values.firstWhere(
      (e) => e.toString().split('.').last == statusString,
      orElse: () => Sweateringstatus.none,
    );
  });
});