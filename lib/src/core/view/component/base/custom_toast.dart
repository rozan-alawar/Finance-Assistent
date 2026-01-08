import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../config/theme/app_color/extensions_color.dart';
import '../../../config/theme/styles/styles.dart';
import '../../../utils/const/sizes.dart';

abstract class CustomToast {
  static void showToast(
    BuildContext context, {
    Widget? child,
    Color? backgroundColor,
    Gradient? backgroundGradient,
    double? borderRadius,
    BoxBorder? border,
    EdgeInsets? margin,
    EdgeInsets? padding,
    ToastGravity toastGravity = ToastGravity.BOTTOM,
    Duration toastDuration = const Duration(seconds: 3),
    Duration fadeDuration = const Duration(milliseconds: 350),
    PositionedToastBuilder? positionedToastBuilder,
  }) {
    final rootNavigator = Navigator.of(context, rootNavigator: true);
    FToast().init(rootNavigator.context);

    final toast = Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? appSwitcherColors(context).toastBGColor,
        gradient: backgroundGradient,
        borderRadius: BorderRadius.circular(4),
        border: border,
      ),
      margin: margin,
      padding: padding ?? const EdgeInsets.all(12),
      child: child,
    );

    FToast().removeCustomToast();
    FToast().showToast(
      child: toast,
      gravity: toastGravity,
      toastDuration: toastDuration,
      fadeDuration: fadeDuration,
      positionedToastBuilder: positionedToastBuilder,
    );
  }

  //using Toast without context will be shown even if the app is in background
  static Future<bool?> showBackgroundToast(
    BuildContext context, {
    String msg = '',
    Color? backgroundColor,
    Toast toastLength = Toast.LENGTH_LONG,
    ToastGravity toastGravity = ToastGravity.BOTTOM,
  }) async {
    return Fluttertoast.showToast(
      msg: msg,
      fontSize: Sizes.font16,
      backgroundColor: backgroundColor ?? appSwitcherColors(context).toastBGColor,
      toastLength: toastLength,
      gravity: toastGravity,
    );
  }

  static void showErrorMessage(BuildContext context, String message) {
    showToast(
      context,
      toastGravity: ToastGravity.TOP,
      backgroundColor: appSwitcherColors(context).dangerColor,
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: appSwitcherColors(context).dangerColor,
          ),
          const SizedBox(width: Sizes.marginH8),
          Expanded(
            child: Text(
              message,
              style: TextStyles.f14(context),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  static void showSuccessMessage(BuildContext context, String message) {
    showToast(
      context,
      toastGravity: ToastGravity.TOP,
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: appSwitcherColors(context).successColor,
          ),
          const SizedBox(width: Sizes.marginH8),
          Expanded(
            child: Text(message, style: TextStyles.f14(context)),
          ),
        ],
      ),
    );
  }
}

/// Use this until https://github.com/ponnamkarthik/FlutterToast/issues/394 is fixed.
/// Simple StatelessWidget which holds the child
/// and creates an [Overlay] to display the toast.
class FToastOverlay extends StatelessWidget {
  const FToastOverlay({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: <OverlayEntry>[
        OverlayEntry(
          builder: (BuildContext ctx) {
            return child;
          },
        ),
      ],
    );
  }
}
