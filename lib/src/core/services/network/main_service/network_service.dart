import 'package:dio/dio.dart';
import '../../../exceptions/app_error_extension.dart';
import '../api_config.dart';

class NetworkService {
  late final Dio _dio;
  final Dio? dioOverride;

  NetworkService({this.dioOverride}) {
    if (dioOverride != null) {
      _dio = dioOverride!;
    } else {
      _dio = Dio(ApiConfig.baseOptions);
      _dio.interceptors.addAll(ApiConfig.interceptorsCollection());
    }
  }
  
  // Public getter if needed, but methods are preferred
  Dio get dio => _dio;

  /// Send GET request to the server
  Future<Response<T>> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _errorHandler(() async {
      return _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    });
  }

  /// Send POST request to the server
  Future<Response<T>> post<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _errorHandler(() async {
      return _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    });
  }

  /// Send PATCH request to the server
  Future<Response<T>> patch<T>({
    required String path,
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _errorHandler(() async {
      return _dio.patch<T>(
        path,
        data: data,
        options: options,
        cancelToken: cancelToken,
      );
    });
  }

  /// Send PUT request to the server
  Future<Response<T>> put<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _errorHandler(() async {
      return _dio.put<T>(
        path,
        queryParameters: queryParameters,
        data: data,
        options: options,
        cancelToken: cancelToken,
      );
    });
  }

  /// Send DELETE request to the server
  Future<Response<T>> delete<T>({
    required String path,
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _errorHandler(() async {
      return _dio.delete<T>(
        path,
        data: data,
        options: options,
        cancelToken: cancelToken,
      );
    });
  }

  Future<T> _errorHandler<T>(Future<T> Function() body) async {
    try {
      return await body();
    } catch (e, st) {
      final er = e.mainApiErrorToServerException();
      throw Error.throwWithStackTrace(er, st);
    }
  }
}
