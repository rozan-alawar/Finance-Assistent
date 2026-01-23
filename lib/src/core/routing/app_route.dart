import 'dart:async';

import 'package:finance_assistent/src/features/auth/presentation/screens/login_screen.dart';
import 'package:finance_assistent/src/features/auth/presentation/screens/register_screen.dart';
import 'package:finance_assistent/src/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:finance_assistent/src/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:finance_assistent/src/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:finance_assistent/src/features/home/presentation/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/reminder/presentation/screens/reminder_screen.dart';
import '../../features/services/presentation/screens/service_screen.dart';
import '../../features/home_shell/screens/home_shell_screen.dart';
import '../../features/budget/presentation/screens/budget_screen.dart';

import 'util/navigation_transitions.dart';
import 'package:finance_assistent/src/core/services/local_storage/hive_service.dart';
import 'package:finance_assistent/src/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:finance_assistent/src/features/auth/presentation/cubits/auth_state.dart';
import 'util/go_router_refresh_stream.dart';

part 'routes/branches/home_branch_routes.dart';
part 'routes/branches/service_branch_routes.dart';
part 'routes/branches/budget_branch_routes.dart';
part 'routes/branches/reminder_branch_routes.dart';
part 'app_route.g.dart';
part 'routes/auth_routes.dart';
part 'routes/home_shell.dart';


final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter goRouter(AuthCubit authCubit) {

  final appRouter = GoRouter(
    debugLogDiagnostics: true,
    restorationScopeId: 'router',
    navigatorKey: _rootNavigatorKey,
    initialLocation: const OnboardingRoute().location,
    routes: $appRoutes,
    observers: [],
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    redirect: (context, state) {
      final authState = authCubit.state;
      final bool isLoggedIn = authState is AuthSuccess;
      final bool isLoggingIn = state.uri.toString() == const LoginRoute().location ||
          state.uri.toString() == const RegisterRoute().location;
      
      final bool onBoardingSeen = HiveService.get(HiveService.settingsBoxName, 'onboarded', defaultValue: false);
      final bool isOnboarding = state.uri.toString() == const OnboardingRoute().location;

      if (!onBoardingSeen && !isOnboarding) {
        return const OnboardingRoute().location;
      }

      if (onBoardingSeen && !isLoggedIn && !isLoggingIn) {
         return const LoginRoute().location;
      }

      if (isLoggedIn) {
        if (isOnboarding || isLoggingIn) {
           return const HomeRoute().location;
        }
      }
      return null;
    },
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
