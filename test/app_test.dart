import 'package:finance_assistent/main.dart';
import 'package:finance_assistent/src/core/di/dependency_injection.dart' as di;
import 'package:finance_assistent/src/core/services/local_storage/hive_service.dart';
import 'package:finance_assistent/src/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:finance_assistent/src/features/auth/data/repo/auth_repository.dart';
import 'package:finance_assistent/src/core/services/network/main_service/network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:finance_assistent/src/core/services/network/api_config.dart';
import 'package:finance_assistent/src/core/services/network/interceptors/content_type_interceptor.dart';
import 'package:finance_assistent/src/core/services/network/interceptors/dio_logger_interceptor.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return '.';
  }
}

void main() {
  setUpAll(() {
    PathProviderPlatform.instance = MockPathProviderPlatform();
  });

  setUp(() async {
    await GetIt.I.reset();
    
    // Initialize Hive manually for test environment
    await Hive.initFlutter();
    
    // We need to initialize DI manually for the test to control dependencies
    final dio = Dio(ApiConfig.baseOptions);
    dio.interceptors.addAll([
      ContentTypeInterceptor(),
      dioInterceptor,
    ]);

    final networkService = NetworkService(dioOverride: dio);
    GetIt.I.registerLazySingleton<NetworkService>(() => networkService);
    GetIt.I.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSource(networkService));
    GetIt.I.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(GetIt.I<AuthRemoteDataSource>()));
  });

  tearDown(() async {
    await Hive.close();
  });

  testWidgets('Full App Flow: Login -> Home -> Logout', (WidgetTester tester) async {
    // Open boxes required by HiveService
    await Hive.openBox(HiveService.guestBoxName);
    await Hive.openBox(HiveService.settingsBoxName);
    
    // Ensure we start clean
    await HiveService.clearBox(HiveService.settingsBoxName);
    await HiveService.clearBox(HiveService.guestBoxName);

    // Pump the app
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // 1. Verify Login Screen
    expect(find.text('Login'), findsOneWidget);

    // Register a user directly via API so we can login
    final random = DateTime.now().millisecondsSinceEpoch;
    final email = 'test_user_$random@example.com';
    final password = 'password123';
    
    final authDataSource = GetIt.I<AuthRemoteDataSource>();
    try {
      await authDataSource.register(
        email: email,
        password: password,
        fullName: 'Test User',
      );
    } catch (e) {
      print('Registration failed: $e');
    }

    // 2. Perform Login
    await tester.enterText(find.ancestor(of: find.text('Email Address'), matching: find.byType(TextFormField)), email);
    await tester.enterText(find.ancestor(of: find.text('Password'), matching: find.byType(TextFormField)), password);
    
    await tester.pump();
    
    // Tap Login
    await tester.tap(find.text('Login').last); 
    
    // Wait for network call. pumpAndSettle might hang if there are ongoing animations (like loading spinners)
    // We'll pump for a fixed duration first, then settle.
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // 3. Verify Home Screen
    // We look for "Your current balance" or "Hello"
    expect(find.text('Your current balance'), findsOneWidget);
    
    // 4. Test Logout
    // Find the avatar/popup menu
    final avatar = find.byType(PopupMenuButton<String>);
    expect(avatar, findsOneWidget);
    
    await tester.tap(avatar);
    await tester.pumpAndSettle();
    
    // Find Logout item
    final logoutItem = find.text('Log Out');
    expect(logoutItem, findsOneWidget);
    
    await tester.tap(logoutItem);
    await tester.pumpAndSettle();
    
    // 5. Verify back to Login Screen
    expect(find.text('Login'), findsOneWidget);
  });
}
