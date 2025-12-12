import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sweater/models/post.dart';

final userPostsProvider = FutureProvider.family<List<Post>, String> ((ref, targetUid) async {
  final _db = FirebaseFirestore.instance;

  final snapshot = await _db
      .collection('posts')
      .where('ownerId', isEqualTo: targetUid)
      .orderBy('createdAt', descending: true)
      .get();

  return snapshot.docs.map((doc) => Post.fromMap(doc.data(), doc.id)).toList();
});