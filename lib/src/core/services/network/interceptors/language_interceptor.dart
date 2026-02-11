import 'package:dio/dio.dart';
import 'package:finance_assistent/src/core/services/local_storage/hive_service.dart';
import '../api_config.dart';

class LanguageInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Default to english or read from Hive if implemented
    final lang = HiveService.get(HiveService.settingsBoxName, 'language', defaultValue: 'en');
    options.headers[ApiConfig.languageHeaderKey] = lang;
    super.onRequest(options, handler);
  }
}
