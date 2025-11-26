import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/post.dart';
import 'package:sweater/features/feed/providers/like_providers.dart';
import 'package:sweater/core/providers/firebase_provider.dart';
import 'package:sweater/utills/time_formatter.dart';

class PostCard extends ConsumerStatefulWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  @override
  Widget build(BuildContext context) {
    final uid = ref.read(firebaseAuthProvider).currentUser?.uid;
    final post = widget.post;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage:
                post.ownerPhotoURL != null
                    ? NetworkImage(post.ownerPhotoURL!)
                    : null,
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
              onPressed:
                  uid == null
                      ? null
                      : () => ref
                          .read(likeControllerProvider)
                          .toggle(post.postId, uid),
              icon: const Icon(Icons.favorite_border),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.mode_comment_outlined),
            ),
          ],
        ),
      ],
    );
  }
}
