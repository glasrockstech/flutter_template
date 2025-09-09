import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_template/features/splash/view/splash_page.dart';
import 'package:flutter_template/features/auth/view/auth_gate.dart';
import 'package:flutter_template/features/home/view/home_page.dart';
import 'package:flutter_template/features/auth/cubit/auth_cubit.dart';

class AppRoutes {
  static const splash = '/';
  static const auth = '/auth';
  static const home = '/home';
}

/// Notifier that triggers go_router redirects when the auth state changes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _sub;
  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

GoRouter createRouter(AuthCubit authCubit) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        name: 'auth',
        builder: (context, state) => const AuthGate(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
    ],
    redirect: (context, state) {
      final status = authCubit.state.status;
      final goingTo = state.uri.path;

      // While unknown (app launching), don't redirect.
      if (status == AuthStatus.unknown) return null;

      final isAuthed = status == AuthStatus.authenticated;
      final inAuth = goingTo == AppRoutes.auth;
      final inHome = goingTo == AppRoutes.home;
      final inSplash = goingTo == AppRoutes.splash;

      if (!isAuthed && (inHome || inSplash)) return AppRoutes.auth;
      if (isAuthed && (inAuth || inSplash)) return AppRoutes.home;
      return null;
    },
  );
}
