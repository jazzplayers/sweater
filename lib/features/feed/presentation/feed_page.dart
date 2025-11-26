import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/post_list_provider.dart';
import 'widgets/post_card.dart';
import 'package:sweater/features/feed/presentation/new_post_page.dart';

class FeedPage extends ConsumerWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(postListProvider);
    final notifier = ref.read(postListProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('SWEATER'), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: () => notifier.refresh(),
        child: ListView.builder(
          itemCount: state.items.length + 1,
          itemBuilder: (context, index) {
            if (index == state.items.length) {
              // 로딩/더보기 트리거
              if (state.hasMore && !state.isLoading) notifier.loadMore();
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child:
                      state.hasMore
                          ? const CircularProgressIndicator()
                          : const Text('끝까지 봤어요'),
                ),
              );
            }
            final post = state.items[index];
            return PostCard(post: post);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const NewPostPage())),
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
