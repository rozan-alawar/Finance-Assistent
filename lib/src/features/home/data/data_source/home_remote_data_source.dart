import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/network/main_service/network_service.dart';
import '../../domain/home_overview.dart';

@immutable
class HomeRemoteDataSource {
  const HomeRemoteDataSource(this.mainApiFacade);
  final NetworkService mainApiFacade;

  String get overviewPath => '/home/overview';
  String get registerTokenPath => '/notifications/push-tokens';
  String get removeTokenPath => '/notifications/push-tokens';

  Future<HomeOverview> getOverview() async {
    final Response<Map<String, dynamic>> response = await mainApiFacade
        .get<Map<String, dynamic>>(path: overviewPath);
    return HomeOverview.fromMap(response.data ?? const {});
  }

  Future<void> registerPushToken({
    required String token,
    String platform = 'mobile',
  }) async {
    await mainApiFacade.post<void>(
      path: registerTokenPath,
      data: {'token': token, 'platform': platform},
    );
  }

  Future<void> removePushToken({required String token}) async {
    await mainApiFacade.delete<void>(
      path: removeTokenPath,
      data: {'token': token},
    );
  }
}
