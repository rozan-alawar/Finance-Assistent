import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/network/main_service/network_service.dart';
import '../../domain/auth_tokens.dart';
import '../../domain/user_app_model.dart';



@immutable
class AuthRemoteDataSource {
  const AuthRemoteDataSource(this.mainApiFacade);
  final NetworkService mainApiFacade;

  String get loginPath => '/api/auth/sign-in';
  String get registerPath => '/api/auth/sign-up';
  
  String get verifySocialTokenGooglePath => '/api/auth/oauth/google';
  String get verifySocialTokenApplePath => '/api/auth/oauth/apple';
  
  String get verifyOtpPath => '/api/auth/forget-password/verify';
  String get resetPasswordPath => '/api/auth/forget-password/reset';

  String get updateCurrencyPath => '/api/user/currency';
  
  String get checkEmailPath => '/api/auth/check-email';

  // =====================================================
  //                    Login
  // =====================================================

  Future<({UserApp user, AuthTokens token})> login({required String email, required String password}) async {
    final response = await mainApiFacade.post<Map<String, dynamic>>(
      path: loginPath,
      data: {'email': email, 'password': password}, 
    );
    return _parseAuthResponse(response.data!);
  }
  
  // =====================================================
  //                    Register
  // =====================================================

  Future<({UserApp user, AuthTokens token})> register({
    required String email,
    required String password,
    required String fullName,
     String? phone,
     bool rememberMe = true
  }) async {
    final response = await mainApiFacade.post<Map<String, dynamic>>(
      path: registerPath,
      data: {
        'email': email, 
        'password': password, 
        'fullName': fullName,
        'rememberMe':rememberMe,
        if(phone != null) 'phone': phone 
      },
    );
    return _parseAuthResponse(response.data!);
  }

  // =====================================================
  //                    Social Login
  // =====================================================

  Future<({UserApp user, AuthTokens token})> verifySocialToken({
    required String token,
    required String socialType, // 'google' or 'apple'
    String? authorizationCode, // For Apple
  }) async {
    final path = socialType == 'google' ? verifySocialTokenGooglePath : verifySocialTokenApplePath;
    
    final data = socialType == 'apple' 
        ? {'identityToken': token, 'authorizationCode': authorizationCode}
        : {'token': token}; // Google usually just sends idToken

    final response = await mainApiFacade.post<Map<String, dynamic>>(
      path: path,
      data: data,
    );
    return _parseAuthResponse(response.data!);
  }

  // =====================================================
  //                    Forget Password
  // =====================================================
  
   Future<bool> checkEmail({required String email}) async {
      final response = await mainApiFacade.post<Map<String, dynamic>>(
      path: checkEmailPath,
      data: {'email': email},
    );
     // Response: { success: true, data: { exists: true }, ... }
     final data = response.data?['data'] as Map<String, dynamic>;
     return data['exists'] as bool;
  }

   Future<void> sendOtp({required String email}) async {
      await mainApiFacade.post<Map<String, dynamic>>(
      path: checkEmailPath,
      data: {'email': email}, // Corrected from 'phone' to 'email'
    );
  }

  /// Returns the resetToken
  Future<String> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await mainApiFacade.post<Map<String, dynamic>>(
      path: verifyOtpPath,
      data: {'email': email, 'code': otp},
    );
    // Response: { success: true, data: { resetToken: "..." }, ... }
    final data = response.data?['data'] as Map<String, dynamic>;
    return data['resetToken'] as String;
  }
  
   Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {
    await mainApiFacade.post<Map<String, dynamic>>(
      path: resetPasswordPath,
      data: {'resetToken': resetToken, 'newPassword': newPassword},
    );
  }

  // =====================================================
  //                    User Actions
  // =====================================================

  Future<void> updateUserCurrency(String currencyCode) async {
    await mainApiFacade.patch<Map<String, dynamic>>(
        path: updateCurrencyPath, 
        data: {'defaultCurrency': currencyCode}
    );
  }
}

({UserApp user, AuthTokens token}) _parseAuthResponse(Map<String, dynamic> response) {
  // Response structure: { success: true, data: { user: {...}, token: "..." } }
  final data = response['data'] as Map<String, dynamic>;
  final userMap = data['user'] as Map<String, dynamic>;
  final tokenString = data['token'] as String;

  final user = UserAppMapper.fromMap(userMap);
  final token = AuthTokens(token: tokenString);

  return (user: user, token: token);
}
