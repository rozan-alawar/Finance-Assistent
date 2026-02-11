import 'package:finance_assistent/src/core/config/theme/app_color/extensions_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/theme/styles/styles.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: appCommonUIColors(context).white,
      title: Text('Logout', style: TextStyles.f18(context).bold),
      content: Text(
        'Are you sure you want to logout?',
        style: TextStyles.f14(context).medium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
