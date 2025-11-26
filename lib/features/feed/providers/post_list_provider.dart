import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweater/core/providers/firebase_provider.dart';
import 'package:sweater/core/repositories/post_repository.dart';
import 'package:sweater/models/post.dart';
import 'package:flutter_riverpod/legacy.dart';

class PostListState {
  final List<Post> items;
  final DocumentSnapshot<Map<String, dynamic>>? lastDoc;
  final bool hasMore;
  final bool isLoading;

  const PostListState({
    this.items = const [],
    this.lastDoc,
    this.hasMore = true,
    this.isLoading = false,
  });

  PostListState copyWith({
    List<Post>? items,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
    bool? hasMore,
    bool? isLoading,
  }) {
    return PostListState(
      items: items ?? this.items,
      lastDoc: lastDoc ?? this.lastDoc,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// ==============================
/// Notifier
/// ==============================
class PostListNotifier extends StateNotifier<PostListState> {
  final FirebaseFirestore _db;
  final PostRepository _repo;
  PostListNotifier(this._db, this._repo) : super(const PostListState());

  static const int pageSize = 10;

  Query<Map<String, dynamic>> _buildQuery({String? ownerUid}) {
    // baseQuery: createdAt desc
    final base = _repo.baseQuery;
    if (ownerUid == null) return base;
    // 특정 UID 게시글만
    return base.where('ownerId', isEqualTo: ownerUid);
  }

  /// 최신 목록 다시 불러오기 (선택적으로 특정 uid만)
  Future<void> refresh({String? ownerUid}) async {
    state = state.copyWith(isLoading: true);

    final Query<Map<String, dynamic>> q = _buildQuery(
      ownerUid: ownerUid,
    ).limit(pageSize);
    final snap = await q.get();

    final posts = snap.docs.map((d) => Post.fromDoc(d)).toList();

    state = PostListState(
      items: posts,
      lastDoc: snap.docs.isNotEmpty ? snap.docs.last : null,
      hasMore: snap.docs.length == pageSize,
      isLoading: false,
    );
  }

  /// 다음 페이지 로드 (refresh 이후에 호출)
  Future<void> loadMore({String? ownerUid}) async {
    if (!state.hasMore || state.isLoading) return;

    state = state.copyWith(isLoading: true);

    Query<Map<String, dynamic>> q = _buildQuery(
      ownerUid: ownerUid,
    ).limit(pageSize);
    if (state.lastDoc != null) {
      q = q.startAfterDocument(state.lastDoc!);
    }

    final snap = await q.get();
    final more = snap.docs.map((d) => Post.fromDoc(d)).toList();

    state = state.copyWith(
      items: [...state.items, ...more],
      lastDoc: snap.docs.isNotEmpty ? snap.docs.last : state.lastDoc,
      hasMore: snap.docs.length == pageSize,
      isLoading: false,
    );
  }

  /// 헬퍼: 특정 유저 피드 새로고침
  Future<void> refreshUser(String ownerUid) => refresh(ownerUid: ownerUid);

  /// 헬퍼: 특정 유저 피드 더 불러오기
  Future<void> loadMoreUser(String ownerUid) => loadMore(ownerUid: ownerUid);
}

/// ==============================
/// Providers
/// ==============================

/// PostList 상태 Provider
final postListProvider = StateNotifierProvider<PostListNotifier, PostListState>(
  (ref) {
    final db = ref.watch(firestoreProvider);
    final repo = ref.watch(postRepositoryProvider);
    final notifier = PostListNotifier(db, repo);
    // 앱 시작 시 전체 피드 최초 로드가 필요하면 활성화:
    // unawaited(notifier.refresh());
    return notifier;
  },
);
