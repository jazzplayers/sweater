import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sweater/features/profile/providers/user_profile_provider.dart';
import 'package:sweater/models/sweateringstatus.dart';
import 'package:sweater/features/profile/model/avatar.dart';

class ProfileAvatar extends ConsumerWidget {
final Avatar avatar;
final double radius = 35.0;

  const ProfileAvatar({
    super.key,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userFutureProvider(avatar.uid));
    final currentUser = ref.watch(currentUserProvider);
    final isMe = currentUser?.uid == avatar.uid;
    final targetUid = isMe ? currentUser!.uid : avatar.uid;
    
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

        return _buildByStatus(avatarWidget, avatar.status);
      },

      
      error: (e, st) => const Text('에러'),
      loading: () => const CircularProgressIndicator(),
    );
  }


  Widget _buildByStatus(Widget child, Sweateringstatus status) {
    switch (avatar.status) {
      case Sweateringstatus.none:
        return child;
      case Sweateringstatus.sweatering:
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.greenAccent, width: 4),
          ),
          child: child,
        );
      case Sweateringstatus.completed:
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.redAccent, width: 4),
          ),
          child: child,
        );
    }
  }
}


