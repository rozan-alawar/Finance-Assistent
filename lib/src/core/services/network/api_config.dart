import 'interceptors/error_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'interceptors/content_type_interceptor.dart';
import 'interceptors/dio_logger_interceptor.dart';
import 'interceptors/language_interceptor.dart';
import 'interceptors/token_interceptor.dart';

abstract class ApiConfig {
  static const String baseUrl = 'https://mock.apidog.com/m1/1184063-1178536-default/';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  static String convertTokenToBearerToken(String token) => 'Bearer $token';

  static const contentTypeHeaderKey = 'content-type';
  static const acceptTypeHeaderKey = 'Accept';
  static const applicationJsonContentType = 'application/json';

  static const withoutToken = 'withoutToken';

  static const tokenHeaderKey = 'Authorization';

  static const languageHeaderKey = 'Accept-Language';

  static final baseOptions = BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: connectTimeout,
    receiveTimeout: receiveTimeout,
  );

  /// Returns: A list of main interceptors.
  static IList<Interceptor> interceptorsCollection() => IList([
    ContentTypeInterceptor(),
    LanguageInterceptor(),
    TokenInterceptor(),
    TokenInterceptor(),
    ErrorInterceptor(),
    dioInterceptor,
  ]);
}
