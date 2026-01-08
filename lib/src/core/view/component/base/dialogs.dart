import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/const/platform_helper.dart';
import 'indicator.dart';

abstract class Dialogs {
  static const loadingDialogName = 'loading';

  // ignore: unused_field
  static final _defaultTitlePadding = PlatformHelper.isMaterialApp
      ? const EdgeInsets.only(top: 24, bottom: 8, right: 24, left: 24)
      : const EdgeInsets.only(top: 16, bottom: 4, right: 16, left: 16);

  // ignore: unused_field
  static final _defaultContentPadding = PlatformHelper.isMaterialApp
      ? const EdgeInsets.symmetric(vertical: 24, horizontal: 24)
      : const EdgeInsets.symmetric(vertical: 16, horizontal: 16);

  // ignore: unused_field
  static const _defaultMaterialActionPadding = EdgeInsets.symmetric(
    vertical: 24,
    horizontal: 24,
  );

  // ignore: unused_field
  static const _defaultMaterialInsetPadding = EdgeInsets.symmetric(
    horizontal: 24,
  );

  // ignore: unused_field
  static final _defaultMaterialShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  );

  static Widget _titleText(BuildContext context, String text) => Text(
    text,
    //Explicitly using style to be applied for CupertinoAlertDialog.
    style: Theme.of(context).dialogTheme.titleTextStyle,
    textAlign: TextAlign.center,
  );

  // ignore: unused_element
  static Widget _contentText(BuildContext context, String text) => Text(
    text,
    //Explicitly using style to be applied for CupertinoAlertDialog.
    style: Theme.of(context).dialogTheme.contentTextStyle,
    textAlign: TextAlign.center,
  );

  static bool _canShowLoading = true;
  static Future<T?> showLoadingDialog<T extends Object?>(
    BuildContext context,
  ) async {
    if (!_canShowLoading) return null;
    _canShowLoading = false;
    final result = await showDialog<T>(
      context: context,
      routeSettings: const RouteSettings(name: loadingDialogName),
      barrierDismissible: false,
      builder: (_) => const LoadingAppIndicator(size: 36),
    );
    _canShowLoading = true;
    return result;
  }

  static Future<T?> showMessage<T extends Object?>(
    BuildContext context, {
    required String message,
  }) async {
    final result = await showDialog<T>(
      context: context,
      routeSettings: const RouteSettings(name: loadingDialogName),
      barrierDismissible: false,
      builder: (_) => Material(
        color: Colors.transparent,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [_titleText(context, message)],
          ),
        ),
      ),
    );
    return result;
  }

  static Future<T?> showConfirmDialog<T extends Object?>(
    BuildContext context, {
    required String title,
    required String description,
    required void Function(BuildContext) confirmCallback,
    required String confirmTitle,
    required String cancelTitle,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CupertinoTheme(
        data: const CupertinoThemeData(brightness: Brightness.light),
        child: CupertinoAlertDialog(
          title: _titleText(context, title),
          content: _contentText(context, description),
          actions: [
            TextButton(
              style: ElevatedButton.styleFrom(),
              onPressed: () => Navigator.pop(context),
              child: Text(cancelTitle),
            ),
            TextButton(
              style: ElevatedButton.styleFrom(),
              onPressed: () => confirmCallback(context),
              child: Text(confirmTitle),
            ),
          ],
        ),
      ),
    );
  }

  static Future<T?> showSingleActionDialog<T extends Object?>(
    BuildContext context, {
    required String title,
    required String description,
    required String actionTitle,
    required void Function(BuildContext) actionCallback,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CupertinoTheme(
        data: const CupertinoThemeData(brightness: Brightness.light),
        child: CupertinoAlertDialog(
          title: _titleText(context, title),
          content: _contentText(context, description),
          actions: [
            TextButton(
              style: TextButton.styleFrom(),
              onPressed: () => actionCallback(context),
              child: Text(actionTitle),
            ),
          ],
        ),
      ),
    );
  }
}
