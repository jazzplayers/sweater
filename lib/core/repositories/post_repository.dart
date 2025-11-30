// lib/features/post_list/post_list_provider.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweater/core/providers/firebase_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class PostRepository {
  /// firebaseFirestore = 문서,컬렉션을 저장하는 데이터베이스
  /// 게시글, 댓글, 사용자 프로필, 좋아요 수 등 텍스트 숫자 기반 데이터 저장
  final FirebaseFirestore _db;

  /// 이미지, 동영상, 파일 등 큰 파일을 저장하는 공간
  final FirebaseStorage _storage;
  PostRepository(this._db, this._storage);

  Query<Map<String, dynamic>> get baseQuery =>
      _db.collection('posts').orderBy('createdAt', descending: true);

  Future<void> toggleLike({required String postId, required String uid}) async {
    final likeRef = _db
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(uid);
    final postRef = _db.collection('posts').doc(postId);

    await _db.runTransaction((tx) async {
      final likeSnap = await tx.get(likeRef);
      final postSnap = await tx.get(postRef);
      final current = (postSnap.data()?['likeCount'] ?? 0) as int;
      if (likeSnap.exists) {
        tx.delete(likeRef);
        tx.update(postRef, {'likeCount': current - 1});
      } else {
        tx.set(likeRef, {
          'uid': uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
        tx.update(postRef, {'likeCount': current + 1});
      }
    });
  }

  Future<bool> isliked({required String postId, required String uid}) async {
    final likedRef =
        await _db
            .collection('posts')
            .doc(postId)
            .collection('likes')
            .doc(uid)
            .get();
    return likedRef.exists;
  }

  Future<String> _uploadImage(String uid, String postId, File file) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = _storage.ref().child('posts/$uid/$postId/$fileName.jpg');
    final task = await ref.putFile(file);
    return await task.ref.getDownloadURL();
  }

  Future<void> createPost({
    required String uid,
    required String userName,
    String? userPhotoURL,
    required List<File> images,
    String? text,
  }) async {
    final userRef = _db.collection('users').doc(uid);
    final postRef = _db.collection('posts').doc(uid);
    final postId = postRef.id;

    final urls = <String>[];
    for (final img in images) {
      final url = await _uploadImage(uid, postId, img);
      urls.add(url);
    }

    await postRef.set({
      'ownerId': uid,
      'ownerName': userName,
      'ownerPhotoURL': userPhotoURL,
      'imageURLs': urls,
      'text': text,
      'likeCount': 0,
      'commentCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await userRef.update({
      'postsCount' : FieldValue.increment(1)
    });
  }
}

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository(
    ref.watch(firestoreProvider),
    ref.watch(storageProvider),
  );
});
