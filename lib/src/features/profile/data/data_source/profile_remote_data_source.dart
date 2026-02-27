import 'package:finance_assistent/src/features/auth/domain/auth_tokens.dart';
import 'package:finance_assistent/src/features/auth/domain/user_app_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/network/main_service/network_service.dart';

@immutable
class ProfileRemoteDataSource {
  const ProfileRemoteDataSource(this.mainApiFacade);
  final NetworkService mainApiFacade;

  String get profilePaths => '/auth/me';
  String changePasswordPath(String id) => '/users/change-password/$id';

  Future<({UserApp user, AuthTokens token})> fetchProfile() async {
    final response = await mainApiFacade.get<Map<String, dynamic>>(
      path: profilePaths,
    );
    return _parseAuthResponse(response.data!);
  }

  Future<String> changePassword({
    required String id,
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    final response = await mainApiFacade.patch<Map<String, dynamic>>(
      path: changePasswordPath(id),
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmNewPassword': confirmNewPassword,
      },
    );
    final data = response.data ?? const {};
    final message = (data['data'] is Map && (data['data'] as Map).containsKey('message'))
        ? ((data['data'] as Map)['message']?.toString() ?? '')
        : (data['message']?.toString() ?? '');
    return message.isNotEmpty ? message : 'Password changed successfully';
  }
}

({UserApp user, AuthTokens token}) _parseAuthResponse(
  Map<String, dynamic> response,
) {
  final data = response['data'] as Map<String, dynamic>;
  final userMap = data['user'] as Map<String, dynamic>;
  final tokenString = data['token'] as String;

  final user = UserAppMapper.fromMap(userMap);
  final token = AuthTokens(token: tokenString);

  return (user: user, token: token);
}
