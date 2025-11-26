// lib/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sweater/features/feed/presentation/feed_page.dart';
import 'package:sweater/core/providers/firebase_provider.dart';
import 'package:sweater/features/auth/login_page.dart';
import 'package:sweater/features/feed/presentation/new_post_page.dart';
import 'package:sweater/features/profile/presentation/profile_page.dart';
import 'dart:async';

final goRouterProvider = Provider<GoRouter>((ref) {
  // ✅ authStateChanges "스트림"을 직접 사용
  final auth = ref.watch(firebaseAuthProvider);
  final authChanges = auth.authStateChanges(); // Stream<User?>

  return GoRouter(
    initialLocation: '/',
    // ✅ 스트림을 listen해서 인증 상태 바뀌면 라우터 갱신
    refreshListenable: GoRouterRefreshStream(authChanges),
    redirect: (context, state) {
      // ✅ 현재 인증 상태
      final isAuthed = auth.currentUser != null;

      final loggingIn = state.matchedLocation == '/login';

      if (!isAuthed) {
        // 미인증 → 로그인으로, 단 이미 /login 이면 그대로
        return loggingIn ? null : '/login';
      }
      // 인증 상태에서 /login 접근 시 홈으로
      if (isAuthed && loggingIn) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      // ✅ ShellRoute로 탭 구조 구성
      ShellRoute(
        builder: (context, state, child) {
          return _HomeShell(child: child); // ✅ 아래에 정의
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder:
                (context, state) => const NoTransitionPage(child: FeedPage()),
          ),
          GoRoute(
            path: '/upload',
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: NewPostPage()),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) {
              final auth = ref.read(firebaseAuthProvider);
              final uid = auth.currentUser!.uid;

              return ProfilePage(targetUid: uid);
            },
          ),
        ],
      ),
    ],
  );
});

/// 하단 탭 + 공통 AppBar 를 제공하는 Shell
class _HomeShell extends StatelessWidget {
  const _HomeShell({required this.child});
  final Widget child;

  int _indexForLocation(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    if (loc.startsWith('/upload')) return 1;
    if (loc.startsWith('/profile')) return 2;
    return 0; // '/'
  }

  @override
  Widget build(BuildContext context) {
    final index = _indexForLocation(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) {
          switch (i) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/upload');
              break;
            case 2:
              context.go('/profile');
              break;
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.add_box_outlined),
            label: 'Upload',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

/// GoRouter가 Stream을 구독해서 notify하는 Listenable
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
