import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sweater/core/providers/post_provider.dart';
import 'package:sweater/features/auth/provider/auth_provider.dart';
import 'package:sweater/features/profile/providers/follow_state.dart';
import 'package:sweater/features/profile/providers/user_profile_provider.dart';
import 'package:sweater/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweater/features/profile/widget/avatar_widget.dart';
import 'package:sweater/features/sweatering/provider/sweatering_provider.dart';


class ProfilePage extends ConsumerWidget {
  final String uid;
  const ProfilePage({
    super.key,
    required this.uid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(userFutureProvider(uid));
    final followState = ref.watch(followControllerProvider(uid));
    final asyncPosts = ref.watch(userPostsProvider(uid));
    final sweateringstatus = ref.watch(sweateringstatusProvider(uid));

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: asyncUser.when(
            // ignore: non_constant_identifier_names
            data: (user) {
              if (user == null) {
                return const Text('Profile');
              }
              return Text(user.displayName);
            },
            error: (e,_) => Text('$e'), 
            loading: () => Text("")),
          actions: [
            IconButton(
              onPressed: () => ref.read(authRepositoryProvider).signOut(),
              icon: Icon(Icons.door_back_door),
            ),
            IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: UserSearchDelegate(),
                );
              },
              icon: Icon(Icons.search),
            )
          ],
        ),
        body: asyncUser.when(
          loading: () => const Center(),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (user) {
                          if (user == null) {
              return const Center(child: Text('User not found'));
            }
      
            final isMe = followState.isMe;
      
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(height: 24),
                    Column(
                      children: [
                    ProfileAvatar(
                      uid: uid,
                    ),
                      ],
                    ),
                    Column(
                      children: [
                    const SizedBox(height: 16),
                    Text(user.displayName, style: const TextStyle(fontSize: 20)),
                      ]
                    ),      
  
                    const SizedBox(height: 8),
                
                    // counts: posts / followers / following
                        _ProfileCount(label: 'Posts', count: user.postsCount),
                        _ProfileCount(label: 'Followers', count: user.followersCount),
                        _ProfileCount(
                          label: 'Following',
                          count: user.followingsCount,
                        ),
                
                    const SizedBox(height: 16),
                
                    // Follow / Edit button
                    
                    // TODO: Tabs for Posts / Workouts later
                  ],
                ),
      
                if (isMe)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              // TODO: go to edit profile
                            },
                            child: const Text('Edit profile'),
                          ),
                        ),
                    ]
                  ),
                )
                    else
                  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              // TODO: go to edit profile
                            },
                            child: const Text('Edit profile'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                followState.isLoading
                                    ? null
                                    : () =>
                                        ref
                                            .read(
                                              followControllerProvider(
                                                  uid,
                                              ).notifier,
                                            ).toggle(),
                            child:
                                followState.isLoading
                                    ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                    : Text(
                                      followState.isFollowing ? 'Following' : 'Follow',
                                    ),
                          ),
                        ),
                    ]
                  ),
                ),
                const TabBar(tabs: [
                  Tab(icon: Icon(Icons.grid_on)),
                  Tab(icon: Icon(Icons.grid_on)),
                  Tab(icon: Icon(Icons.grid_on)),
                ]),
Expanded(
  child: TabBarView(
    children: [
      // 1번째 탭: 나의 게시물
      asyncPosts.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const Center(child: Text('No Posts Yet'));
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              final thumbNailUrl = post.imageURLs.isNotEmpty ? post.imageURLs.first : null;
              if (thumbNailUrl == null) {
                return Container(color: Colors.grey);
              }
              return Image.network(
                post.imageURLs.first,
                fit: BoxFit.cover,
              );
            },
          );
        },
        error: (e, st) => Center(child: Text('Error: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),

      // 2, 3번째 탭은 아직 더미면 이렇게
      GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemBuilder: (context, index) {
          return Container(color: Colors.blue);
        },
      ),
      GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemBuilder: (context, index) {
          return Container(color: Colors.blue);
        },
      ),
    ],
  ),
)
              ],
            );
          },
        ),
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


class UserSearchDelegate extends SearchDelegate<UserProfile?> {

  Future<List<UserProfile>> _searchUsers(String query) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
    .collection('users')
    .orderBy('displayName')
    .startAt([query])
    .endAt([query + '\uf8ff'])
    .get();

    return snapshot.docs
        .map((doc) => UserProfile.fromMap(doc.data(), doc.id))
        .toList();
  }
  
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final userProfiles = _searchUsers(query);
    // Implement search result display
    return FutureBuilder<List<UserProfile>>(
      future: userProfiles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No results found for "$query"'));
        }

        final users = snapshot.data!;
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              title: Text(user.displayName),
              subtitle: Text(user.email),
              onTap: () {
                close(context, user);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implement search suggestions
    return ListView(
      children: [
        ListTile(
          title: Text('Search for "$query"'),
          onTap: () {
            showResults(context);
          },
        ),
      ],
    );
  }
}