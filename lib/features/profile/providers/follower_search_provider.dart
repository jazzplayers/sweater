import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sweater/features/profile/providers/follow_provider.dart';
import 'package:sweater/features/profile/model/user_profile.dart';

final followerSearchQueryProvider = StateProvider.family<String, String>(
  (ref, uid) => '',
);

final filteredFollowersProvider = Provider.family<List<UserProfile>, String>((
  ref,
  uid,
) {
  final query = ref.watch(followerSearchQueryProvider(uid));
  final followers = ref.watch(followersProvider(uid)).value ?? [];

  if (query.isEmpty) return followers;
  return followers
      .where(
        (user) => user.displayName.toLowerCase().contains(query.toLowerCase()),
      )
      .toList();
});

final SearchQueryProvider = StateProvider.family<String, String>(
  (ref, uid) => "",
);
