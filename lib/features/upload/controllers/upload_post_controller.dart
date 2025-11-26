import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/repositories/post_repository.dart';
import 'package:sweater/core/providers/firebase_provider.dart';

final uploadPostControllerProvider =
    AsyncNotifierProvider<UploadPostController, void>(
      () => UploadPostController(),
    );

class UploadPostController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// 초기 상태에서는 아무것도 하지 않겠다.
  /// 이 Provider는 생성되자마자 아무것도 로드 하지 않고, upload()가 호출될 때만 동작한다.
  Future<void> upload({required List<File> images, String? text}) async {
    final auth = ref.read(firebaseAuthProvider);
    final user = auth.currentUser!;
    final db = ref.read(firestoreProvider);
    final userDoc = await db.collection('users').doc(user.uid).get();
    final userName = userDoc.data()?['displayName'] ?? user.email;
    final userPhoto = userDoc.data()?['photoURL'];

    state = const AsyncLoading();
    try {
      await ref
          .read(postRepositoryProvider)
          .createPost(
            uid: user.uid,
            userName: userName,
            userPhotoURL: userPhoto,
            images: images,
            text: text,
          );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
