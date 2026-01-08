import 'package:flutter/material.dart';

Future<void> showCustomBottomSheet({
  required BuildContext context,
  required Widget child,
  Color? backgroundColor,
  double? elevation,
  ShapeBorder? shape,
  Clip? clipBehavior,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
    builder: (context) => FractionallySizedBox(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: child,
      ),
    ),
  );
}
