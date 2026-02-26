import 'dart:developer';

import 'package:finance_assistent/firebase_options.dart';
import 'package:finance_assistent/src/core/config/theme/app_theme.dart';
import 'package:finance_assistent/src/core/di/dependency_injection.dart' as di;
import 'package:finance_assistent/src/core/routing/app_route.dart';
import 'package:finance_assistent/src/core/routing/navigation_service.dart';
import 'package:finance_assistent/src/core/services/local_storage/hive_service.dart';
import 'package:finance_assistent/src/core/services/sync/sync_service.dart';
import 'package:finance_assistent/src/core/view/component/base/custom_toast.dart';
import 'package:finance_assistent/src/features/auth/data/repo/auth_repository.dart';
import 'package:finance_assistent/src/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:finance_assistent/src/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {
    log("Firebase Error");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (_) {
    log("Firebase Error");
  }
  await HiveService.init();
  await di.init();
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

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthCubit(di.sl<AuthRepository>())..checkSession(),
        ),
        BlocProvider(lazy: true, create: (_) => ProfileCubit(di.sl())),
      ],

      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Finance Assistent',
            theme: AppTheme(
              themeMode: AppThemeMode.light,
            ).getThemeData('ExpoArabic'),
            routerConfig: goRouter(context.read<AuthCubit>()),
            builder: (_, child) {
              return GestureDetector(
                onTap: NavigationService.removeFocus,
                child: FToastOverlay(child: child!),
              );
            },
          );
        },
      ),
    );
  }
}

///moamen@example.com
///StrongP@ssw0rd
