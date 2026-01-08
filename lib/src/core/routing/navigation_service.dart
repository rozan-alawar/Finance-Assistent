import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../view/component/base/dialogs.dart';

abstract class NavigationService {
  static void removeFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static void _closeOverlays() {
    FToast().removeQueuedCustomToasts();
  }

  static void pop<T>(
    BuildContext context, {
    T? result,
    bool closeOverlays = false,
  }) {
    if (closeOverlays) {
      _closeOverlays();
    }
    if (context.canPop()) {
      // Note: GoRouter logging will wrongly log that it's popping current route
      // when popping a dialog: https://github.com/flutter/flutter/issues/119237
      return context.pop(result);
    }
  }

  static void popDialog<T extends Object?>(
    BuildContext context, {
    T? result,
  }) {
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      return navigator.pop(result);
    }
  }

  static void popLoadingDialog(BuildContext context) {
    final navigator = Navigator.of(context, rootNavigator: true);
    navigator.popUntil(
      (route) {
        return route.settings.name != Dialogs.loadingDialogName;
      },
    );
  }

  /// Closes all routes & dialogs until the route of the passed context is the top-most route.
  static void popUntilCurrent(BuildContext context) {
    Navigator.of(context).popUntil((_) {
      return ModalRoute.of(context)!.isCurrent;
    });
  }
}
