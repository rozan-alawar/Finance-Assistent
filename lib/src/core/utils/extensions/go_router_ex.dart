import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension ThemeEx on BuildContext {
  String get currentLocation => GoRouterState.of(this).matchedLocation;
}
