import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finance_assistent/src/core/config/theme/app_theme.dart';
import 'package:finance_assistent/src/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:finance_assistent/src/features/auth/presentation/cubits/auth_state.dart';
import 'package:finance_assistent/src/features/auth/data/repo/auth_repository.dart';
import 'package:finance_assistent/src/features/auth/domain/auth_tokens.dart';
import 'package:finance_assistent/src/features/auth/domain/user_app_model.dart';
import 'package:finance_assistent/src/features/home_shell/components/home_shell_bottom_nav_bar.dart';
import 'package:finance_assistent/src/features/home_shell/utils/tab_item.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<bool> checkEmail({required String email}) {
    throw UnimplementedError();
  }

  @override
  Future<({UserApp user, AuthTokens token})> login({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }

  @override
  Future<({UserApp user, AuthTokens token})> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    bool rememberMe = true,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> sendOtp({required String email}) {
    throw UnimplementedError();
  }

  @override
  Future<String> verifyOtp({required String email, required String otp}) {
    throw UnimplementedError();
  }

  @override
  Future<({UserApp user, AuthTokens token})> verifySocialToken({
    required String token,
    required String socialType,
    String? authorizationCode,
  }) {
    throw UnimplementedError();
  }
}

class TestAuthCubit extends AuthCubit {
  TestAuthCubit(AuthState state) : super(FakeAuthRepository()) {
    emit(state);
  }
}

void main() {
  testWidgets('Guest tapping Profile shows login required dialog', (tester) async {
    TabItem? selectedTab;

    await tester.pumpWidget(
      BlocProvider<AuthCubit>(
        create: (_) => TestAuthCubit(AuthGuest()),
        child: MaterialApp(
          theme: AppTheme(themeMode: AppThemeMode.light).getThemeData('ExpoArabic'),
          home: Scaffold(
            body: const SizedBox.shrink(),
            bottomNavigationBar: HomeShellBottomNavBar(
              currentTab: TabItem.home,
              onSelectTab: (tab) => selectedTab = tab,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(selectedTab, isNull);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Profile'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Log in'),
      ),
      findsOneWidget,
    );
  });
}
