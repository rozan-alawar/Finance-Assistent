import 'package:finance_assistent/src/core/config/theme/app_theme.dart';
import 'package:finance_assistent/src/core/routing/app_route.dart';
import 'package:finance_assistent/src/core/routing/navigation_service.dart';
import 'package:finance_assistent/src/core/view/component/base/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_assistent/src/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:finance_assistent/src/core/services/local_storage/hive_service.dart';
import 'package:finance_assistent/src/core/services/sync/sync_service.dart';
import 'package:finance_assistent/src/features/profile/presentation/pages/profile_page.dart';
import 'package:finance_assistent/src/features/profile/presentation/pages/accounting_page.dart';
import 'package:finance_assistent/src/features/Reports/presentation/pages/reports_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  SyncService().init();
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

    return BlocProvider(
      create: (context) => AuthCubit()..checkSession(),
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Finance Assistent',
      theme: AppTheme(themeMode: AppThemeMode.light).getThemeData('ExpoArabic'),
      routerConfig: goRouter(context.read<AuthCubit>()),
      builder: (_, child) {
        return GestureDetector(
          onTap: NavigationService.removeFocus,
          child: FToastOverlay(child: child!),
        );
      },
    );
        }
      ),
    );
  }
}