import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sweater/core/providers/firebase_provider.dart';
import 'package:sweater/features/profile/model/avatar.dart';
import 'package:sweater/features/profile/repository/avatar_repository.dart';
import 'package:sweater/features/profile/model/avatar.dart';
import 'package:sweater/features/profile/widget/avatar_widget.dart';


final avatarRepositoryProvider = Provider<AvatarRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return AvatarRepository(firestore);
});

final avatarsStreamProvider = StreamProvider<List<Avatar>>((ref) {
  final avatarRepository = ref.watch(avatarRepositoryProvider);
  return avatarRepository.globalAvatarsStream();
});
