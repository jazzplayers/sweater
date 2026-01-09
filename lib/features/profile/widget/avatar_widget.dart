import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sweater/features/profile/providers/user_profile_provider.dart';
import 'package:sweater/features/sweatering/model/sweateringstatus.dart';
import 'package:sweater/features/sweatering/provider/sweatering_provider.dart';

class ProfileAvatar extends ConsumerWidget {
final String uid;
final double radius = 35.0;

  const ProfileAvatar({
    super.key,
    required this.uid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sweateringstatus = ref.watch(sweateringstatusProvider(uid));
    final userAsync = ref.watch(userFutureProvider(uid));
    return userAsync.when(
      data: (user) {
        final avatarWidget = CircleAvatar(
          radius: radius,
          backgroundImage:
              (user == null || user.photoURL == null || user.photoURL!.isEmpty)
                  ? null
                  : NetworkImage(user.photoURL!),
          child: (user == null || user.photoURL == null || user.photoURL!.isEmpty)
              ? Icon(
                  Icons.person,
                  size: radius,
                )
              : null,
        );

        return _buildByStatus(avatarWidget, sweateringstatus);
      },

      
      error: (e, st) => const Text('에러'),
      loading: () => const CircularProgressIndicator(),
    );
  }
  Widget _buildByStatus(Widget avatar, Sweateringstatus status) {
    switch (status) {
      case Sweateringstatus.sweatering:
        return Stack(
          alignment: Alignment.center,
          children: [
            avatar,
            Container(
              width: radius * 2,
              height: radius * 2,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ],
        );
      case Sweateringstatus.completed:
        return Stack(
          alignment: Alignment.center,
          children: [
            avatar,
            Container(
              width: radius * 2,
              height: radius * 2,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        );
      default:
        return avatar;
    }
  }
}


