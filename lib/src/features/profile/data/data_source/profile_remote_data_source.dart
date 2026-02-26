import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/exceptions/app_error_extension.dart';
import '../../../../core/services/network/main_service/network_service.dart';
import '../../../auth/domain/user_app_model.dart';

@immutable
class ProfileRemoteDataSource {
  const ProfileRemoteDataSource(this.mainApiFacade);

  final NetworkService mainApiFacade;

  List<String> get profilePaths => const [
        '/user/profile',
        '/user/me',
        '/users/me',
        '/user',
      ];

  String get updateCurrencyPath => '/user/currency';

  Future<UserApp> fetchProfile() async {
    final dio = mainApiFacade.dio;

    for (final path in profilePaths) {
      final response = await dio.get<Map<String, dynamic>>(
        path,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      final status = response.statusCode ?? 0;
      if (status == 404) {
        continue;
      }
      if (status == 401 || status == 403) {
        throw const UserFriendlyException(
          'Your session expired. Please sign in again.',
        );
      }
      if (status < 200 || status >= 300) {
        throw UserFriendlyException('Failed to load profile (HTTP $status).');
      }

      final root = response.data ?? const <String, dynamic>{};
      final dynamic data = root['data'];

      final dynamic userMap = switch (data) {
        final Map<String, dynamic> m when m['user'] is Map => m['user'],
        final Map<String, dynamic> m when m['id'] != null => m,
        _ => root['user'],
      };

      if (userMap is! Map) {
        throw const UserFriendlyException('Invalid profile response.');
      }

      return UserApp.fromMap(Map<String, dynamic>.from(userMap));
    }

    throw const UserFriendlyException('Profile endpoint not found.');
  }

  Future<void> updateDefaultCurrency({required String currencyId}) async {
    await mainApiFacade.patch<Map<String, dynamic>>(
      path: updateCurrencyPath,
      data: {
        'currencyId': currencyId,
        'defaultCurrencyId': currencyId,
      },
    );
  }
}
