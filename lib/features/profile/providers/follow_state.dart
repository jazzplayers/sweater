import 'package:sweater/core/repositories/follow_repository.dart';
import 'package:riverpod/legacy.dart';
import 'package:sweater/features/profile/providers/follow_provider.dart';
import 'package:sweater/features/profile/providers/user_profile_provider.dart';

class FollowState {
  final bool isFollowing;
  final bool isMe;
  final bool isLoading;

  const FollowState({
    required this.isFollowing,
    required this.isMe,
    this.isLoading = false,
  });

  FollowState copyWith({bool? isFollowing, bool? isMe, bool? isLoading}) =>
      FollowState(
        isFollowing: isFollowing ?? this.isFollowing,
        isMe: isMe ?? this.isMe,
        isLoading: isLoading ?? this.isLoading,
      );
}

class FollowController extends StateNotifier<FollowState> {
  final FollowRepository _repo;
  final String me;
  final String target;

  FollowController(this._repo, this.me, this.target)
    : super(FollowState(isMe: me == target, isFollowing: false)) {
    _init();
  }

  Future<void> _init() async {
    if (me == target) return;
    final followed = await _repo.isFollowing(me: me, target: target);
    state = state.copyWith(isFollowing: followed);
  }

  Future<void> toggle() async {
    if (state.isMe || state.isLoading) return;
    state = state.copyWith(isLoading: true);
    try {
      await _repo.toggleFollow(me: me, target: target);
      state = state.copyWith(isFollowing: !state.isFollowing, isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final followControllerProvider =
    StateNotifierProvider.family<FollowController, FollowState, String>((
      ref,
      targetUid,
    ) {
      final repo = ref.watch(followRepositoryProvider);
      final me = ref.watch(currentUserProvider)?.uid ?? '';
      return FollowController(repo, me, targetUid);
    });
