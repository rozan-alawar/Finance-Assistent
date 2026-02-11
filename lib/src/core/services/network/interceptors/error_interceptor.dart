import 'package:dio/dio.dart';


class _RejectError implements Exception {
  const _RejectError(this.message);

  final String message;
}

class ErrorInterceptor extends Interceptor {
  ErrorInterceptor();

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      
      // Check 'success' field if present
      if (data.containsKey('success')) {
        if (data['success'] == false) {
           _reject(response, data, handler);
           return;
        }
      } 
      // Fallback to 'code' check if 'success' is missing but 'code' is present
      else if (data.containsKey('code')) {
        final code = data['code'];
        if (code != 200 && code != 201) {
           _reject(response, data, handler);
           return;
        }
      }
    }
    return handler.next(response);
  }

  void _reject(Response response, Map<String, dynamic> data, ResponseInterceptorHandler handler) {
      final dioException = DioException(
        response: response,
        requestOptions: response.requestOptions,
        error: _RejectError('${data['message']}'),
        message: '${data['message']}',
        stackTrace: StackTrace.current,
        type: DioExceptionType.badResponse,
      );
      handler.reject(dioException, true);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;

    if ([400, 404, 409, 422, 429].any((code) => code == statusCode) || err.error is _RejectError) {
      final response = err.response!;
      final data = response.data as Map<String, dynamic>;
      final error = data['message'];
      final response2 = Response(
        statusCode: response.statusCode,
        data: data,
        requestOptions: response.requestOptions,
        statusMessage: response.statusMessage,
        isRedirect: response.isRedirect,
        redirects: response.redirects,
        extra: response.extra,
        headers: response.headers,
      );
      final newErr = err.copyWith(
        response: response2,
        error: error,
        message: '$error',
        type: DioExceptionType.badResponse,
      );
      return handler.reject(newErr);
    }
    return handler.next(err);
  }
}
