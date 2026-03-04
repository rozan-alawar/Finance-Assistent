import 'package:dio/dio.dart';

import '../../../../../core/network/api_endpoints.dart';
import '../models/category_breakdown_model.dart';
import '../models/category_model.dart';
import '../models/donut_chart_model.dart';
import '../models/expense_model.dart';
import '../models/expense_overview_model.dart';

/// Remote data source for expense operations via API
abstract class ExpenseRemoteDataSource {
  /// Get expenses overview (total balance, income, expenses)
  /// GET /api/v1/expenses/overview
  Future<ExpenseOverviewModel> getExpensesOverview({
    String? period,
    int? month,
    String? from,
    String? to,
  });

  /// Get expenses categories breakdown
  /// GET /api/v1/expenses/categories/breakdown
  Future<CategoriesBreakdownResponse> getCategoriesBreakdown({
    String? period,
    int? month,
    String? from,
    String? to,
  });

  /// Get expenses donut chart data
  /// GET /api/v1/expenses/charts/donut
  Future<DonutChartResponse> getDonutChartData({
    String? period,
    int? month,
    String? from,
    String? to,
  });

  /// Get all expenses
  /// GET /api/v1/expenses
  Future<List<ExpenseModel>> getExpenses({
    String? from,
    String? to,
    String? category,
  });

  /// Create a new expense
  /// POST /api/v1/expenses
  Future<ExpenseModel> createExpense(ExpenseModel expense);

  /// Update an existing expense
  /// PUT /api/v1/expenses/{id}
  Future<ExpenseModel> updateExpense(String id, ExpenseModel expense);

  /// Delete an expense
  /// DELETE /api/v1/expenses/{id}
  Future<void> deleteExpense(String id);

  /// Get all categories
  /// GET /api/v1/categories
  Future<CategoriesResponse> getCategories();
}

/// Implementation of ExpenseRemoteDataSource using Dio
class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  final Dio dio;

  ExpenseRemoteDataSourceImpl({required this.dio});

  /// Build query params for the expense endpoints
  Map<String, dynamic> _buildQueryParams({
    String? period,
    int? month,
    String? from,
    String? to,
  }) {
    final queryParams = <String, dynamic>{};
    if (period != null) queryParams['period'] = period;
    if (month != null) queryParams['month'] = month;
    if (from != null) queryParams['from'] = from;
    if (to != null) queryParams['to'] = to;
    return queryParams;
  }

  @override
  Future<ExpenseOverviewModel> getExpensesOverview({
    String? period,
    int? month,
    String? from,
    String? to,
  }) async {
    try {
      final queryParams = _buildQueryParams(
        period: period,
        month: month,
        from: from,
        to: to,
      );

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
    String? period,
    int? month,
    String? from,
    String? to,
  }) async {
    try {
      final queryParams = _buildQueryParams(
        period: period,
        month: month,
        from: from,
        to: to,
      );

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
    String? period,
    int? month,
    String? from,
    String? to,
  }) async {
    try {
      final queryParams = _buildQueryParams(
        period: period,
        month: month,
        from: from,
        to: to,
      );

      final response = await dio.get(
        ApiEndpoints.expensesDonutChart,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      return DonutChartResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<List<ExpenseModel>> getExpenses({
    String? from,
    String? to,
    String? category,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (from != null) queryParams['from'] = from;
      if (to != null) queryParams['to'] = to;
      if (category != null) queryParams['category'] = category;

      final response = await dio.get(
        ApiEndpoints.expenses,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final data = response.data;
      List<dynamic> expensesList;

      if (data is List) {
        expensesList = data;
      } else if (data is Map<String, dynamic>) {
        // Handle wrapped: { "data": [...] } or { "expenses": [...] }
        final rawData = data['data'] ?? data['expenses'] ?? [];
        expensesList = rawData is List ? rawData : [];
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

      final data = response.data;
      if (data is Map<String, dynamic>) {
        // Handle wrapped: { "data": { ... } }
        if (data.containsKey('data') && data['data'] is Map<String, dynamic>) {
          return ExpenseModel.fromJson(data['data'] as Map<String, dynamic>);
        }
        return ExpenseModel.fromJson(data);
      }

      // Fallback: return the original expense with generated id
      return expense;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<ExpenseModel> updateExpense(String id, ExpenseModel expense) async {
    try {
      final response = await dio.put(
        '${ApiEndpoints.expenses}/$id',
        data: expense.toJson(),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data.containsKey('data') && data['data'] is Map<String, dynamic>) {
          return ExpenseModel.fromJson(data['data'] as Map<String, dynamic>);
        }
        return ExpenseModel.fromJson(data);
      }
      return expense;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    try {
      await dio.delete('${ApiEndpoints.expenses}/$id');
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
      if (data['message'] is String) return data['message'] as String;
      if (data['error'] is Map<String, dynamic>) {
        final error = data['error'] as Map<String, dynamic>;
        return error['message'] as String? ?? 'Unknown error';
      }
      if (data['error'] is String) return data['error'] as String;
      return 'Unknown error';
    }
    return 'Unknown error';
  }
}
