import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sweater/core/providers/firebase_provider.dart';
import 'package:sweater/core/repositories/post_repository.dart';

final likeControllerProvider = Provider((ref) => _LikeController(ref));

class _LikeController {
  final Ref ref;
  _LikeController(this.ref);

  Future<void> toggle(String postId, String uid) async {
    await ref.read(postRepositoryProvider).toggleLike(postId: postId, uid: uid);
    // 낙관적 업데이트를 넣고 싶다면 postListProvider.state 수정 로직 추가 가능
  }
}

final isLikedProvider = FutureProvider.family<bool, String>((
  ref,
  postId,
) async {
  final uid = ref.watch(firebaseAuthProvider).currentUser!.uid;
  return ref.watch(postRepositoryProvider).isliked(postId: postId, uid: uid);
});
