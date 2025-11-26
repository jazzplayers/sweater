import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sweater/features/auth/auth_provider.dart';
import 'package:sweater/features/profile/providers/follow_provider.dart';
import 'package:sweater/features/profile/providers/follow_state.dart';

class ProfilePage extends ConsumerWidget {
  final String targetUid;
  const ProfilePage({super.key, required this.targetUid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(userProfileProvider(targetUid));
    final followState = ref.watch(followControllerProvider(targetUid));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
            icon: Icon(Icons.door_back_door),
          ),
        ],
      ),
      body: asyncUser.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('User not found'));
          }

          final isMe = followState.isMe;

          return Column(
            children: [
              const SizedBox(height: 24),
              CircleAvatar(
                radius: 40,
                backgroundImage:
                    user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                child:
                    user.photoURL == null
                        ? const Icon(Icons.person, size: 40)
                        : null,
              ),
              const SizedBox(height: 16),
              Text(user.displayName, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 8),
              Text(user.email),
              const SizedBox(height: 16),

              // counts: posts / followers / following
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ProfileCount(label: 'Posts', count: user.postsCount),
                  _ProfileCount(label: 'Followers', count: user.followersCount),
                  _ProfileCount(
                    label: 'Following',
                    count: user.followingsCount,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Follow / Edit button
              if (isMe)
                OutlinedButton(
                  onPressed: () {
                    // TODO: go to edit profile
                  },
                  child: const Text('Edit profile'),
                )
              else
                ElevatedButton(
                  onPressed:
                      followState.isLoading
                          ? null
                          : () =>
                              ref
                                  .read(
                                    followControllerProvider(
                                      targetUid,
                                    ).notifier,
                                  )
                                  .toggle(),
                  child:
                      followState.isLoading
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : Text(
                            followState.isFollowing ? 'Following' : 'Follow',
                          ),
                ),

              // TODO: Tabs for Posts / Workouts later
            ],
          );
        },
      ),
    );
  }
}

class _ProfileCount extends StatelessWidget {
  final String label;
  final int count;
  const _ProfileCount({required this.label, required this.count, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Text(
            '$count',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }
}
