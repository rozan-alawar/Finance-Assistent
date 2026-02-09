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

  String get loginPath => '/auth/sign-in';
  String get registerPath => '/auth/sign-up';
  
  String get verifySocialTokenGooglePath => '/auth/google';
  String get verifySocialTokenApplePath => '/api/auth/oauth/apple';
  
  String get requestOtpPath => '/auth/password-reset/request';
  String get verifyOtpPath => '/auth/password-reset/verify';
  String get resetPasswordPath => '/auth/password-reset/confirm';

  String get updateCurrencyPath => '/user/currency';
  String get lisCurrenciesPath => '/currencies';

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
        : {'token': token};

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
     final data = response.data?['data'] as Map<String, dynamic>;
     return data['exists'] as bool;
  }

   Future<void> sendOtp({required String email}) async {
      await mainApiFacade.post<Map<String, dynamic>>(
      path: requestOtpPath,
      data: {'email': email},
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


}

({UserApp user, AuthTokens token}) _parseAuthResponse(Map<String, dynamic> response) {
  final data = response['data'] as Map<String, dynamic>;
  final userMap = data['user'] as Map<String, dynamic>;
  final tokenString = data['token'] as String;

  final user = UserAppMapper.fromMap(userMap);
  final token = AuthTokens(token: tokenString);

  return (user: user, token: token);
}
