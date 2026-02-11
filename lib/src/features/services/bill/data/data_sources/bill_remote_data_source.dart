import 'package:dio/dio.dart';

import '../../../../../core/network/api_endpoints.dart';
import '../../domain/entities/bill_status.dart';
import '../models/bill_model.dart';

/// Remote data source for bill operations via API
abstract class BillRemoteDataSource {
  /// Get all bills
  /// GET /api/v1/bills
  Future<List<BillModel>> getBills({
    bool? isGroupBill,
    String? searchQuery,
  });

  /// Get bill by ID
  /// GET /api/v1/bills/{id}
  Future<BillModel> getBillById(String id);

  /// Create a new bill
  /// POST /api/v1/bills
  Future<BillModel> createBill(Map<String, dynamic> billData, {bool isGroup});

  /// Update a bill
  /// PUT /api/v1/bills/{id}
  Future<BillModel> updateBill(String id, Map<String, dynamic> billData, {bool isGroup});

  /// Delete a bill
  /// DELETE /api/v1/bills/{id}
  Future<void> deleteBill(String id);

  /// Update bill payment status
  /// PATCH /api/v1/bills/{id}/status
  Future<BillModel> updateBillStatus(String id, BillStatus status);

  /// Smart parse bill using AI
  /// POST /api/v1/bills/smart-parse
  Future<BillModel> smartParseBill(String imageData);
}

/// Implementation of BillRemoteDataSource using Dio
class BillRemoteDataSourceImpl implements BillRemoteDataSource {
  final Dio dio;

  BillRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<BillModel>> getBills({
    bool? isGroupBill,
    String? searchQuery,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (isGroupBill != null) {
        queryParams['isGroupBill'] = isGroupBill;
      }
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['search'] = searchQuery;
      }

      final response = await dio.get(
        ApiEndpoints.bills,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final data = response.data;
      List<dynamic> billsList;

      if (data is List) {
        billsList = data;
      } else if (data is Map<String, dynamic>) {
        billsList = data['bills'] as List<dynamic>? ??
            data['data'] as List<dynamic>? ??
            [];
      } else {
        billsList = [];
      }

      return billsList.map((json) {
        final map = json as Map<String, dynamic>;
        final isGroup = map['isGroupBill'] as bool? ?? 
                        map['isGroup'] as bool? ?? false;
        if (isGroup) {
          return GroupBillModel.fromJson(map) as BillModel;
        }
        return BillModel.fromJson(map);
      }).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<BillModel> getBillById(String id) async {
    try {
      final response = await dio.get('${ApiEndpoints.bills}/$id');
      final data = response.data as Map<String, dynamic>;
      
      final isGroup = data['isGroupBill'] as bool? ?? 
                      data['isGroup'] as bool? ?? false;
      if (isGroup) {
        return GroupBillModel.fromJson(data) as BillModel;
      }
      return BillModel.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<BillModel> createBill(Map<String, dynamic> billData, {bool isGroup = false}) async {
    try {
      final response = await dio.post(
        ApiEndpoints.bills,
        data: billData,
      );

      final data = response.data as Map<String, dynamic>;
      if (isGroup) {
        return GroupBillModel.fromJson(data) as BillModel;
      }
      return BillModel.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<BillModel> updateBill(String id, Map<String, dynamic> billData, {bool isGroup = false}) async {
    try {
      final response = await dio.put(
        '${ApiEndpoints.bills}/$id',
        data: billData,
      );

      final data = response.data as Map<String, dynamic>;
      if (isGroup) {
        return GroupBillModel.fromJson(data) as BillModel;
      }
      return BillModel.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> deleteBill(String id) async {
    try {
      await dio.delete('${ApiEndpoints.bills}/$id');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<BillModel> updateBillStatus(String id, BillStatus status) async {
    try {
      final response = await dio.patch(
        '${ApiEndpoints.bills}/$id/status',
        data: {'status': status.id},
      );

      final data = response.data as Map<String, dynamic>;
      final isGroup = data['isGroupBill'] as bool? ?? 
                      data['isGroup'] as bool? ?? false;
      if (isGroup) {
        return GroupBillModel.fromJson(data) as BillModel;
      }
      return BillModel.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<BillModel> smartParseBill(String imageData) async {
    try {
      final response = await dio.post(
        ApiEndpoints.billsSmartParse,
        data: {'image': imageData},
      );

      return BillModel.fromJson(response.data as Map<String, dynamic>);
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

