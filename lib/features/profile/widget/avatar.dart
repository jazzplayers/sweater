import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sweater/features/profile/providers/user_profile_provider.dart';

class ProfileAvatar extends ConsumerWidget {
  final String uid;
  final double size;
  final VoidCallback? onTap;
  const ProfileAvatar({
    super.key,
    required this.uid,
    this.size = 40,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userFutureProvider(uid));
    return userAsync.when(
      data: (user) {
        final avatar = CircleAvatar(
          radius: size,
          backgroundImage:
              (user == null || user.photoURL == null || user.photoURL!.isEmpty)
                  ? null
                  : NetworkImage(user.photoURL!),
          child:
              (user == null || user.photoURL == null || user.photoURL!.isEmpty)
                  ? const Icon(Icons.person)
                  : null,
        );
        if (onTap == null) return avatar;
        return GestureDetector(onTap: onTap, child: avatar);
      },
      error: (e, st) => const Text('에러'),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
