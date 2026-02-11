import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../api_config.dart';

@immutable
class ContentTypeInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[ApiConfig.acceptTypeHeaderKey] = ApiConfig.applicationJsonContentType;
    if (options.data is! FormData) {
      options.headers[ApiConfig.contentTypeHeaderKey] = ApiConfig.applicationJsonContentType;
    }

    return handler.next(options);
  }
}
