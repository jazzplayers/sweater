import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sweater/features/profile/providers/avatar_provider.dart';
import 'package:sweater/features/profile/providers/user_profile_provider.dart';
import 'package:sweater/models/sweateringstatus.dart';
import 'package:sweater/features/profile/model/avatar.dart';
import 'package:sweater/models/user_profile.dart';
import 'package:sweater/features/profile/providers/user_profile_provider.dart';

class ProfileAvatar extends ConsumerWidget {
final Sweateringstatus status;
final String uid;
final double radius = 35.0;

  const ProfileAvatar({
    super.key,
    required this.uid,
    required this.status,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

        return _buildByStatus(avatarWidget, status);
      },

      
      error: (e, st) => const Text('에러'),
      loading: () => const CircularProgressIndicator(),
    );
  }


  Widget _buildByStatus(Widget child, Sweateringstatus status) {
    switch (status) {
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


