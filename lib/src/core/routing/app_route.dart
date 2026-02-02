import 'dart:async';

import 'package:finance_assistent/src/features/auth/presentation/screens/login_screen.dart';
import 'package:finance_assistent/src/features/auth/presentation/screens/register_screen.dart';
import 'package:finance_assistent/src/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:finance_assistent/src/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:finance_assistent/src/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:finance_assistent/src/features/home/presentation/screens/notification_screen.dart';
import 'package:finance_assistent/src/features/home/presentation/screens/select_currency_screen.dart';
import 'package:finance_assistent/src/features/debts/presentation/screens/add_debt_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/reminder/presentation/screens/reminder_screen.dart';
import '../../features/services/presentation/screens/service_screen.dart';
import '../../features/home_shell/screens/home_shell_screen.dart';
import '../../features/budget/presentation/screens/budget_screen.dart';
import '../../features/ask_ai/presentation/screens/ask_ai_screen.dart';

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
part 'routes/onboarding_route.dart';

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

      final bool onBoardingSeen = HiveService.get(
        HiveService.settingsBoxName,
        'onboarded',
        defaultValue: false,
      );
      
      final bool isCurrencySelected = HiveService.get(
        HiveService.settingsBoxName,
        'currency_selected',
        defaultValue: true, // Default true for existing users/guests
      );

      final String location = state.uri.toString();

      final bool isOnboarding = location == const OnboardingRoute().location;
      final bool isLogin = location == const LoginRoute().location;
      final bool isRegister = location == const RegisterRoute().location;

      /// Force onboarding ONLY if not completed
      if (!onBoardingSeen && !isOnboarding) {
        return const OnboardingRoute().location;
      }

      /// If onboarding is done, redirect to auth screens
      if (onBoardingSeen && isOnboarding) {
        return const LoginRoute().location;
      }

      /// If user is logged in, block auth screens
      if (isLoggedIn && (isLogin || isRegister)) {
        return const HomeRoute().location;
      }

      /// Force currency selection if logged in and not selected (Post-Signup)
      if (isLoggedIn && !isCurrencySelected) {
         if (location.startsWith('/select-currency')) return null;
         return SelectCurrencyRoute(isSignup: true).location;
      }

      /// If NOT logged in (and not Guest), and trying to access protected routes
      /// Assuming AuthInitial means not logged in.
      /// Guest is handled by AuthGuest state.
      final bool isGuest = authState is AuthGuest;
      if (!isLoggedIn && !isGuest && onBoardingSeen) {
        // Allow access to login, register, forgot password, etc.
        // If the user is on a protected route, redirect to Login.
        // We need to define what are public routes.
        // For now, let's just say if we are in AuthInitial, we should probably be at Login 
        // unless we are already at an auth screen.
        
        final bool isAuthRoute = location.startsWith('/auth'); // Assuming auth routes start with /auth
        // Actually, looking at imports, routes are likely classes.
        // Let's check if the current location is one of the auth routes.
        
        final isAuthPage = isLogin || isRegister || location.contains('forget-password') || location.contains('reset-password') || location.contains('otp-verification');
        
        if (!isAuthPage) {
           return const LoginRoute().location;
        }
      }
      
      /// Force currency selection for new users
      if (isLoggedIn && !isCurrencySelected) {
         // Only redirect if not already there to avoid loop
         if (location != const SelectCurrencyRoute(isOnboarding: true).location) {
             return const SelectCurrencyRoute(isOnboarding: true).location;
         }
      }

      /// Guests are allowed everywhere else
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
