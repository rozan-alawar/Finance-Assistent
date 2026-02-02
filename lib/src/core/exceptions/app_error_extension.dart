import 'package:dio/dio.dart';

extension AppErrorExtension on Object {
  Exception mainApiErrorToServerException() {
    if (this is DioException) {
      final dioError = this as DioException;
      // You can expand this logic to parse specific server error formats
      // For example:
      // final message = dioError.response?.data['message'] ?? dioError.message;
      return Exception(dioError.message ?? 'Unknown Network Error');
    }
    return Exception(toString());
  }
}
