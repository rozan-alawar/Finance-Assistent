import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/presentation/cubits/auth_state.dart';

extension ThemeEx on BuildContext {
  String get currentLocation => GoRouterState.of(this).matchedLocation;
}

extension AuthX on AuthState {
  bool get isGuest => this is AuthGuest;
  bool get isLoggedIn => this is AuthSuccess;
}
