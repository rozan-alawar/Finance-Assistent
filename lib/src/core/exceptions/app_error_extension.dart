import 'package:dio/dio.dart';

class UserFriendlyException implements Exception {
  final String message;

  const UserFriendlyException(this.message);

  @override
  String toString() => message;
}

extension AppErrorExtension on Object {
  Exception mainApiErrorToServerException() {
    if (this is DioException) {
      final dioError = this as DioException;
      final message = _mapDioErrorToMessage(dioError);
      return UserFriendlyException(message);
    }
    return UserFriendlyException(_fallbackMessage(toString()));
  }
}

String _mapDioErrorToMessage(DioException dioError) {
  final statusCode = dioError.response?.statusCode;
  if (statusCode != null) {
    if (statusCode >= 500) {
      return 'Something went wrong on our side. Please try again later.';
    }
    switch (statusCode) {
      case 401:
        return 'Your session expired or your email or password is incorrect. Please sign in again or reset your password.';
      case 403:
        return "You don't have permission to do that. Please use a different account or contact support.";
      case 404:
        return "We couldn't find what you're looking for. Please check and try again.";
      case 400:
      case 422:
        return 'Some details are missing or invalid. Please review and try again.';
      case 409:
        return 'That already exists. Please use a different value and try again.';
      case 429:
        return "You're doing that too often. Please wait a moment and try again.";
    }
  }

  switch (dioError.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return 'The connection timed out. Please check your internet and try again.';
    case DioExceptionType.connectionError:
      return 'We couldn’t connect. Please check your internet and try again.';
    case DioExceptionType.cancel:
      return 'Request canceled. Please try again.';
    case DioExceptionType.badCertificate:
      return 'Secure connection failed. Please try again.';
    case DioExceptionType.badResponse:
      return 'We couldn’t complete your request. Please try again.';
    case DioExceptionType.unknown:
      return 'Something went wrong. Please try again.';
  }
}

String _fallbackMessage(String raw) {
  final cleaned = _stripTechnical(raw);
  if (cleaned.trim().isEmpty) {
    return 'Something went wrong. Please try again.';
  }
  return cleaned;
}

String _stripTechnical(String raw) {
  const technicalTokens = [
    'Exception:',
    'DioException',
    'DioError',
    'RequestOptions',
    'validateStatus',
    'Axios',
    'Dio',
  ];

  var cleaned = raw;
  for (final token in technicalTokens) {
    cleaned = cleaned.replaceAll(token, '');
  }
  return cleaned.trim();
}
