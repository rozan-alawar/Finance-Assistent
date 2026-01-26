import 'package:finance_assistent/src/core/config/theme/app_color/extensions_color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/app_route.dart';

Future<void> showLoginRequiredDialog(
    BuildContext context, {
      String? title,
      String? message,
    }) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => AlertDialog(
      backgroundColor: appCommonUIColors(context).white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        title ?? 'Login Required',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(
        message ??
            'Please log in to access this feature and stay updated with what’s new.',
      ),
      actions: [
        TextButton(
          onPressed: () {
            if(context.canPop()){
              context.pop();
            }
          },
          child: const Text('Maybe later'),
        ),
        ElevatedButton(
          onPressed: () {
            if(context.canPop()){
              context.pop();
            }            context.push(const LoginRoute().location);
          },
          child: const Text('Log in'),
        ),
      ],
    ),
  );
}
