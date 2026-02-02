import 'dart:io';
import 'package:finance_assistent/main.dart';
import 'package:finance_assistent/src/core/di/dependency_injection.dart' as di;
import 'package:finance_assistent/src/core/services/local_storage/hive_service.dart';
import 'package:finance_assistent/src/features/auth/data/repo/auth_repository.dart';
import 'package:finance_assistent/src/features/auth/domain/user_app_model.dart';
import 'package:finance_assistent/src/features/auth/domain/auth_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
class MockPathProviderPlatform extends Fake with MockPlatformInterfaceMixin implements PathProviderPlatform {
  final Directory tempDir = Directory.systemTemp.createTempSync();
  
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return tempDir.path;
  }
}

class MockAuthRepository implements AuthRepository {
  @override
  Future<({UserApp user, AuthTokens token})> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    bool rememberMe = true,
  }) async {
       return (
         token: AuthTokens(token: 'mock_token'),
         user: UserApp(id: 1, email: email, fullName: fullName, role: 'USER', status: 'ACTIVE', defaultCurrency: 'USD', currentBalance: '0', points: '0', avatarAssetId: '', provider: 'email', providerId: ''),
       );
  }

  @override
  Future<UserApp> updateUserCurrency({required String userId, required String currency, required String token}) async {
       return UserApp(id: 1, email: 'test@example.com', fullName: 'Test User', role: 'USER', status: 'ACTIVE', defaultCurrency: currency, currentBalance: '0', points: '0', avatarAssetId: '', provider: 'email', providerId: '');
  }

  @override
  Future<void> logout() async {}

  @override
  Future<({UserApp user, AuthTokens token})> login({required String email, required String password}) async {
    return (
         token: AuthTokens(token: 'mock_token'),
         user: UserApp(id: 1, email: email, fullName: 'Test User', role: 'USER', status: 'ACTIVE', defaultCurrency: 'USD', currentBalance: '0', points: '0', avatarAssetId: '', provider: 'email', providerId: ''),
    );
  }
  
  @override
  Future<bool> checkEmail({required String email}) async => true;
  
  @override
  Future<void> sendOtp({required String email}) async {}
  
  @override
  Future<String> verifyOtp({required String email, required String otp}) async => "token";
  
  @override
  Future<void> resetPassword({required String resetToken, required String newPassword}) async {}
  
  @override
  Future<({UserApp user, AuthTokens token})> verifySocialToken({required String token, required String socialType, String? authorizationCode}) {
    throw UnimplementedError();
  }
}

Future<void> pumpUntilFound(WidgetTester tester, Finder finder, {int maxPumps = 50}) async {
  for (int i = 0; i < maxPumps; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }
  fail('Widget not found: $finder');
}

void main() {
  setUpAll(() async {
     PathProviderPlatform.instance = MockPathProviderPlatform();
     await HiveService.init();
     final getIt = GetIt.instance;
     if (!getIt.isRegistered<AuthRepository>()) {
        getIt.registerSingleton<AuthRepository>(MockAuthRepository());
     }
  });

  tearDownAll(() async {
    await Hive.close();
    await GetIt.I.reset();
  });
  
  tearDown(() async {
      await HiveService.clearBox(HiveService.settingsBoxName);
      await HiveService.clearBox(HiveService.guestBoxName);
  });

  testWidgets('Signup Flow: Register -> Select Currency -> Logout -> Login', (WidgetTester tester) async {
      await HiveService.put(HiveService.settingsBoxName, 'onboarded', true);
      await HiveService.put(HiveService.settingsBoxName, 'currency_selected', true);
      await HiveService.delete(HiveService.settingsBoxName, 'token');
      await HiveService.delete(HiveService.settingsBoxName, 'user');
      await HiveService.put(HiveService.settingsBoxName, 'isGuest', true);

      await tester.pumpWidget(const MyApp());
      await pumpUntilFound(tester, find.byType(PopupMenuButton<String>));
      final avatar = find.byType(PopupMenuButton<String>);
      expect(avatar, findsOneWidget);
      await tester.tap(avatar);
      await pumpUntilFound(tester, find.text('Log In'));

      await tester.tap(find.text('Log In'));
      await pumpUntilFound(tester, find.text('Login'));

      final registerFinder = find.textContaining('Register');
      if (registerFinder.evaluate().isNotEmpty) {
          await tester.tap(registerFinder.last);
      } else {
           await tester.tap(find.textContaining('Sign Up').last);
      }
      await pumpUntilFound(tester, find.byType(TextFormField));

      final fields = find.byType(TextFormField);
      if (fields.evaluate().length >= 4) {
        await tester.enterText(fields.at(0), 'Test User'); 
        await tester.enterText(fields.at(1), 'newuser@example.com');
        await tester.enterText(fields.at(2), '1234567890');
        await tester.enterText(fields.at(3), 'password123');
        if (fields.evaluate().length > 4) {
             await tester.enterText(fields.at(4), 'password123');
        }
      }

      final btn = find.byType(ElevatedButton);
      if (btn.evaluate().isNotEmpty) {
          await tester.tap(btn.last);
      } else {
          await tester.tap(find.text('Sign Up').last);
      }
      await pumpUntilFound(tester, find.text('Select Currency'));

      await tester.tap(find.text('EUR')); 
      await pumpUntilFound(tester, find.text('Continue'));

      await tester.tap(find.text('Continue'));
      await pumpUntilFound(tester, find.text('Login'));
  });
}
