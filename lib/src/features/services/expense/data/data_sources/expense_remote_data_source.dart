import 'package:dio/dio.dart';

import '../../../../../core/network/api_endpoints.dart';
import '../models/category_breakdown_model.dart';
import '../models/category_model.dart';
import '../models/donut_chart_model.dart';
import '../models/expense_model.dart';
import '../models/expense_overview_model.dart';

/// Remote data source for expense operations via API
abstract class ExpenseRemoteDataSource {
  /// Get expenses overview (total balance, income, expenses, percentage change)
  /// GET /api/v1/expenses/overview
  Future<ExpenseOverviewModel> getExpensesOverview({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get expenses categories breakdown
  /// GET /api/v1/expenses/categories/breakdown
  Future<CategoriesBreakdownResponse> getCategoriesBreakdown({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get expenses donut chart data
  /// GET /api/v1/expenses/charts/donut
  Future<DonutChartResponse> getDonutChartData({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get all expenses
  /// GET /api/v1/expenses
  Future<List<ExpenseModel>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
  });

  /// Create a new expense
  /// POST /api/v1/expenses
  Future<ExpenseModel> createExpense(ExpenseModel expense);

  /// Get all categories
  /// GET /api/v1/categories
  Future<CategoriesResponse> getCategories();
}

/// Implementation of ExpenseRemoteDataSource using Dio
class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  final Dio dio;

  ExpenseRemoteDataSourceImpl({required this.dio});

  @override
  Future<ExpenseOverviewModel> getExpensesOverview({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await dio.get(
        ApiEndpoints.expensesOverview,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      return ExpenseOverviewModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<CategoriesBreakdownResponse> getCategoriesBreakdown({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await dio.get(
        ApiEndpoints.expensesCategoriesBreakdown,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      return CategoriesBreakdownResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<DonutChartResponse> getDonutChartData({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await dio.get(
        ApiEndpoints.expensesDonutChart,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      return DonutChartResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<List<ExpenseModel>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }
      if (categoryId != null) {
        queryParams['category'] = categoryId;
      }

      final response = await dio.get(
        ApiEndpoints.expenses,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final data = response.data;
      List<dynamic> expensesList;

      if (data is List) {
        expensesList = data;
      } else if (data is Map<String, dynamic>) {
        expensesList =
            data['expenses'] as List<dynamic>? ??
            data['data'] as List<dynamic>? ??
            [];
      } else {
        expensesList = [];
      }

      return expensesList
          .map((json) => ExpenseModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<ExpenseModel> createExpense(ExpenseModel expense) async {
    try {
      final response = await dio.post(
        ApiEndpoints.expenses,
        data: expense.toJson(),
      );

      return ExpenseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<CategoriesResponse> getCategories() async {
    try {
      final response = await dio.get(ApiEndpoints.categories);

      final data = response.data;
      if (data is List) {
        return CategoriesResponse.fromList(data);
      }
      return CategoriesResponse.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Handle Dio errors and convert to readable exceptions
  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception(
          'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = _extractErrorMessage(error.response?.data);
        return Exception('Server error ($statusCode): $message');
      case DioExceptionType.cancel:
        return Exception('Request was cancelled.');
      case DioExceptionType.connectionError:
        return Exception('No internet connection.');
      default:
        return Exception('An unexpected error occurred: ${error.message}');
    }
  }

  /// Extract error message from response data
  String _extractErrorMessage(dynamic data) {
    if (data == null) return 'Unknown error';
    if (data is String) return data;
    if (data is Map<String, dynamic>) {
      // Check for top-level message
      if (data['message'] is String) return data['message'] as String;
      // Check for nested error object: {"error": {"message": "..."}}
      if (data['error'] is Map<String, dynamic>) {
        final error = data['error'] as Map<String, dynamic>;
        return error['message'] as String? ?? 'Unknown error';
      }
      // Check for error as a plain string
      if (data['error'] is String) return data['error'] as String;
      return 'Unknown error';
    }
    return 'Unknown error';
  }
}
