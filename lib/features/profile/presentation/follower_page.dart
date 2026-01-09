import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sweater/features/feed/presentation/widgets/bottomsheet.dart';
import 'package:sweater/features/profile/providers/follow_provider.dart';
import 'package:sweater/features/profile/providers/follower_search_provider.dart';
import 'package:sweater/features/profile/widget/avatar_widget.dart';
import 'package:sweater/features/sweatering/model/sweateringstatus.dart';
import 'package:sweater/features/profile/providers/user_profile_provider.dart';
import 'package:sweater/features/profile/model/avatar.dart';


class FollowerPage extends ConsumerWidget {
  final String targetUid;
  const FollowerPage({super.key, required this.targetUid,});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(userStreamProvider(targetUid));
    final followersAsync = ref.watch(followersProvider(targetUid));
    final Sweateringstatus status =
        ref.watch(sweateringStateProvider); 
    return Scaffold(
      appBar: AppBar(
        title: asyncUser.when(
          data: (user) {
            if (user == null) {
              return const Text('User not Found');
            }
            return Text(user.displayName);
          },
          error: (e, st) => const Text('에러'),
          loading: () => const CircularProgressIndicator(),
        ),
      ),
      body: Row(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: "Search Followers",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              ref.read(followerSearchQueryProvider(targetUid).notifier).state =
                  value;
            },
          ),
          followersAsync.when(
            data: (followers) {
              return ListView.builder(
                itemCount: followers.length,
                itemBuilder: (context, index) {
                  final user = followers[index];
                  return ListTile(
                    leading: ProfileAvatar(
                      uid: user.uid,
                    ),
                    title: Text(user.displayName),
                    onTap: () {
                      context.push('/profile/${user.uid}');
                    },
                    /// 상대 프로필 페이지로 이동
                  );
                },
              );
            },
            error: (e, st) => const Text('error'),
            loading: () => const CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
