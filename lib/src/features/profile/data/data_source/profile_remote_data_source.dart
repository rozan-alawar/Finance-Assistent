import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/exceptions/app_error_extension.dart';
import '../../../../core/services/network/main_service/network_service.dart';
import '../../../auth/domain/auth_tokens.dart';
import '../../../auth/domain/user_app_model.dart';




@immutable
class ProfileRemoteDataSource {
  const ProfileRemoteDataSource(this.mainApiFacade);

  final NetworkService mainApiFacade;

  String get profilePaths => "/auth/me";

  Future<({UserApp user, AuthTokens token})> fetchProfile() async {
    final response = await mainApiFacade.get<Map<String, dynamic>>(
      path: profilePaths,
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    return _parseAuthResponse(response.data!);
  }



  ({UserApp user, AuthTokens token}) _parseAuthResponse(Map<String, dynamic> response) {
    final data = response['data'] as Map<String, dynamic>;
    final userMap = data['user'] as Map<String, dynamic>;
    final tokenString = data['token'] as String;

    final user = UserAppMapper.fromMap(userMap);
    final token = AuthTokens(token: tokenString);

    return (user: user, token: token);
  }

}
