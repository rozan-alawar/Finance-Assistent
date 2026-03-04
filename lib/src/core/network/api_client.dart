import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../services/network/interceptors/dio_logger_interceptor.dart';
import '../services/network/interceptors/token_interceptor.dart';

/// API Client configuration using Dio
class ApiClient {
  static const String baseUrl = 'https://gsg-project-group-5.vercel.app/api/v1';

  static Dio? _dio;

  /// Get the Dio instance (singleton)
  static Dio get dio {
    _dio ??= _createDio();
    return _dio!;
  }

  /// Create and configure Dio instance
  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add token interceptor to attach auth token from Hive
    dio.interceptors.add(TokenInterceptor());

    // Add pretty logging for all requests
    dio.interceptors.add(dioInterceptor);

    // Add Dio's built-in logger for additional logging in debug mode
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
          logPrint: (object) => debugPrint('DioLog: $object'),
        ),
      );
    }

    return dio;
  }
}
