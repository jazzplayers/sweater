import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/post.dart';
import 'package:sweater/features/feed/providers/like_providers.dart';
import 'package:sweater/core/providers/firebase_provider.dart';
import 'package:sweater/utills/time_formatter.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLikedAsync = ref.watch(isLikedProvider(post.postId));
    final uid = ref.read(firebaseAuthProvider).currentUser?.uid;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage:
                post.ownerPhotoURL != null
                    ? NetworkImage(post.ownerPhotoURL!)
                    : null,
            child: post.ownerPhotoURL == null ? const Icon(Icons.person) : null,
          ),
          title: Text(post.ownerName),
          subtitle: Text(formatTimeAgo(post.createdAt)),
        ),
        AspectRatio(
          aspectRatio: 1,
          child: PageView(
            children:
                post.imageURLs.map((url) {
                  return CachedNetworkImage(imageUrl: url, fit: BoxFit.cover);
                }).toList(),
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: isLikedAsync.maybeWhen(
                data:
                    (isLiked) => Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : null,
                    ),
                orElse: () => const Icon(Icons.favorite_border),
              ), // 실시간 내 좋아요 여부는 상세/추가 구현
              onPressed:
                  uid == null
                      ? null
                      : () => ref
                          .read(likeControllerProvider)
                          .toggle(post.postId, uid),
            ),
            IconButton(
              icon: const Icon(Icons.mode_comment_outlined),
              onPressed: () {
                /* TODO: 댓글 화면으로 이동 */
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('좋아요 ${post.likeCount}개 · 댓글 ${post.commentCount}개'),
        ),
        if ((post.text ?? '').isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(post.text!),
          ),
        const SizedBox(height: 16),
        const Divider(height: 1),
      ],
    );
  }
}
