import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/const/time.dart';

class FadePageRoute<T> extends CustomTransitionPage<T> {
  FadePageRoute({
    required super.child,
    required LocalKey pageKey,
    super.transitionDuration = AnimationDurations.slowDuration,
  }) : super(
         reverseTransitionDuration: AnimationDurations.defaultDuration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return FadeTransition(
             key: pageKey,
             opacity: CurvedAnimation(
               parent: animation,
               curve: Curves.easeIn,
               reverseCurve: Curves.easeOut,
             ),
             child: child,
           );
         },
       );
}
