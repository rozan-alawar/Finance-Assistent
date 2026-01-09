import 'package:finance_assistent/src/core/config/theme/app_theme.dart';
import 'package:finance_assistent/src/core/routing/app_route.dart';
import 'package:finance_assistent/src/core/routing/navigation_service.dart';
import 'package:finance_assistent/src/core/view/component/base/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Finance Assistent',
      theme: AppTheme(themeMode: AppThemeMode.light).getThemeData('ExpoArabic'),
      routerConfig: goRouter(),
      builder: (_, child) {
        return GestureDetector(
          onTap: NavigationService.removeFocus,
          child: FToastOverlay(child: child!),
        );
      },
    );
  }
}
