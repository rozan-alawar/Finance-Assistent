import 'package:dio/dio.dart';
import 'package:finance_assistent/src/core/services/local_storage/hive_service.dart';
import 'package:fpdart/fpdart.dart';

import '../api_config.dart';

class TokenInterceptor extends QueuedInterceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final withoutToken = options.extra[ApiConfig.withoutToken] != null;
    if (withoutToken) return handler.next(options);

    // Read directly from Hive
    final String? token = HiveService.get(HiveService.settingsBoxName, 'token');

    if (token != null && token.isNotEmpty) {
      options.headers[ApiConfig.tokenHeaderKey] =
          ApiConfig.convertTokenToBearerToken(token);
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {

      HiveService.put(HiveService.settingsBoxName, 'isGuest', true); 
    }
    return handler.next(err);
  }
}

