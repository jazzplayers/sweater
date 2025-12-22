import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sweater/models/sweateringstatus.dart';
import '../../providers/post_list_provider.dart';
import '../widgets/post_card.dart';
import 'package:sweater/features/feed/presentation/widgets/bottomsheet.dart';
import 'package:sweater/features/profile/providers/avatar_provider.dart';
import 'package:sweater/features/profile/widget/avatar_widget.dart';


class FeedPage extends ConsumerWidget {
  final String uid;
  const FeedPage({super.key, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Sweateringstatus status = ref.watch(sweateringStateProvider);
    final state = ref.watch(postListProvider);
    final notifier = ref.read(postListProvider.notifier);
    final avatarsStream = ref.watch(avatarsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('SWEATER'), centerTitle: true),

      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!state.isLoading && state.hasMore && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            // Load more posts when scrolled to the bottom
            if (state.hasMore && !state.isLoading) notifier.loadMore();
          }
          return false;
        },
        child: RefreshIndicator(
          onRefresh: () => notifier.refresh(),
                child: ListView.builder(
                  itemCount: state.items.length + 2,
                  itemBuilder: (context, index) {
                     if (index == 0) {
                      return SizedBox(
                        height: 80,
                        child: avatarsStream.when(
                          data: (avatars) {
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: avatars.length,
                              itemBuilder: (context, avatarIndex) {
                                final avatar = avatars[avatarIndex];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                                  child: ProfileAvatar(uid: uid, status: avatar.status),
                                );
                              },
                            );
                          },
                          loading: () =>  Center(child: Text(''),),
                          error: (e, st) => Center(child: Text('Error: $e')),
                        ),
                      );
                    }

                    if (index == state.items.length + 1) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: state.hasMore
                              ? const CircularProgressIndicator()
                              : const Text('No more posts'),
                        ),
                      );
                    }
                    final post = state.items[index - 1];
                    return PostCard(uid: uid, post: post, status: status);
                  },
                ),
              ),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return const SweateringBottomSheet();
            },
          );
        },
        child: const Icon(Icons.bike_scooter),
      ),
    );
  }
}
