import 'package:finance_assistent/src/features/auth/presentation/screens/login_screen.dart';
import 'package:finance_assistent/src/features/auth/presentation/screens/register_screen.dart';
import 'package:finance_assistent/src/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:finance_assistent/src/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:finance_assistent/src/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'util/navigation_transitions.dart';

part 'app_route.g.dart';
part 'routes/auth_routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter goRouter() {
  final listenToRefresh = ValueNotifier<bool?>(null);

  final appRouter = GoRouter(
    debugLogDiagnostics: true,
    restorationScopeId: 'router',
    navigatorKey: _rootNavigatorKey,
    initialLocation: const LoginRoute().location,
    routes: $appRoutes,
    observers: [],
    refreshListenable: listenToRefresh,
  );

  return appRouter;
}

Uri? getCurrentLocation(GoRouter router) {
  if (router.routerDelegate.currentConfiguration.isEmpty) return null;
  final lastMatch = router.routerDelegate.currentConfiguration.last;
  final matchList = lastMatch is ImperativeRouteMatch
      ? lastMatch.matches
      : router.routerDelegate.currentConfiguration;
  return matchList.uri;
}
