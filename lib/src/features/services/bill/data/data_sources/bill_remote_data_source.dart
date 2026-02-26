import 'package:dio/dio.dart';

import '../../../../../core/network/api_endpoints.dart';
import '../../domain/entities/bill.dart';
import '../../domain/entities/bill_status.dart';
import '../models/bill_model.dart';

/// Remote data source for bill operations via API
abstract class BillRemoteDataSource {
  /// Get all bills with optional type filter and pagination
  /// GET /api/v1/bills?type=individual|group&page=1&limit=20
  Future<List<BillEntity>> getBills({String? type, int? page, int? limit});

  /// Get bill by ID
  /// GET /api/v1/bills/{id}
  Future<BillEntity> getBillById(String id);

  /// Create a new bill
  /// POST /api/v1/bills
  Future<BillEntity> createBill(Map<String, dynamic> billData);

  /// Update a bill
  /// PUT /api/v1/bills/{id}
  Future<BillEntity> updateBill(String id, Map<String, dynamic> billData);

  /// Delete a bill
  /// DELETE /api/v1/bills/{id}
  Future<void> deleteBill(String id);

  /// Update bill payment status
  /// PATCH /api/v1/bills/{id}/status
  Future<BillEntity> updateBillStatus(String id, BillStatus status);

  /// Smart parse bill using AI
  /// POST /api/v1/bills/smart-parse
  Future<BillEntity> smartParseBill(String imageData);
}

/// Implementation of BillRemoteDataSource using Dio
class BillRemoteDataSourceImpl implements BillRemoteDataSource {
  final Dio dio;

  BillRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<BillEntity>> getBills({
    String? type,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (type != null) queryParams['type'] = type;
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final response = await dio.get(
        ApiEndpoints.bills,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final data = response.data;
      List<dynamic> billsList;

      if (data is List) {
        billsList = data;
      } else if (data is Map<String, dynamic>) {
        // Handle wrapped: { "data": { "items": [...], "meta": {...} } }
        final responseData = data['data'];
        if (responseData is Map<String, dynamic>) {
          billsList = responseData['items'] as List<dynamic>? ?? [];
        } else if (responseData is List) {
          billsList = responseData;
        } else {
          billsList =
              data['bills'] as List<dynamic>? ??
              data['items'] as List<dynamic>? ??
              [];
        }
      } else {
        billsList = [];
      }

      return billsList.map((json) {
        final map = json as Map<String, dynamic>;
        final billType = map['type'] as String? ?? 'individual';
        if (billType.toLowerCase() == 'group') {
          return GroupBillModel.fromJson(map) as GroupBillEntity;
        }
        return BillModel.fromJson(map);
      }).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<BillEntity> getBillById(String id) async {
    try {
      final response = await dio.get('${ApiEndpoints.bills}/$id');
      final data = response.data as Map<String, dynamic>;

      // Handle wrapped: { "data": { ... } }
      final billData =
          data.containsKey('data') && data['data'] is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : data;

      final type = billData['type'] as String? ?? 'individual';
      if (type.toLowerCase() == 'group') {
        return GroupBillModel.fromJson(billData);
      }
      return BillModel.fromJson(billData);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<BillEntity> createBill(Map<String, dynamic> billData) async {
    try {
      final response = await dio.post(ApiEndpoints.bills, data: billData);

      final data = response.data;
      if (data is Map<String, dynamic>) {
        // Handle wrapped: { "data": { ... } }
        final responseData =
            data.containsKey('data') && data['data'] is Map<String, dynamic>
            ? data['data'] as Map<String, dynamic>
            : data;

        final type =
            responseData['type'] as String? ??
            billData['type'] as String? ??
            'individual';
        if (type.toLowerCase() == 'group') {
          return GroupBillModel.fromJson(responseData);
        }
        return BillModel.fromJson(responseData);
      }

      return BillModel.fromJson(billData);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<BillEntity> updateBill(
    String id,
    Map<String, dynamic> billData,
  ) async {
    try {
      final response = await dio.put(
        '${ApiEndpoints.bills}/$id',
        data: billData,
      );

      final data = response.data as Map<String, dynamic>;
      final responseData =
          data.containsKey('data') && data['data'] is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : data;

      final type = responseData['type'] as String? ?? 'individual';
      if (type.toLowerCase() == 'group') {
        return GroupBillModel.fromJson(responseData);
      }
      return BillModel.fromJson(responseData);
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
  Future<BillEntity> updateBillStatus(String id, BillStatus status) async {
    try {
      final response = await dio.patch(
        '${ApiEndpoints.bills}/$id/status',
        data: {'status': status.id},
      );

      final data = response.data as Map<String, dynamic>;
      final responseData =
          data.containsKey('data') && data['data'] is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : data;

      final type = responseData['type'] as String? ?? 'individual';
      if (type.toLowerCase() == 'group') {
        return GroupBillModel.fromJson(responseData);
      }
      return BillModel.fromJson(responseData);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<BillEntity> smartParseBill(String imageData) async {
    try {
      final response = await dio.post(
        ApiEndpoints.billsSmartParse,
        data: {'image': imageData},
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final responseData =
            data.containsKey('data') && data['data'] is Map<String, dynamic>
            ? data['data'] as Map<String, dynamic>
            : data;
        return BillModel.fromJson(responseData);
      }
      return BillModel.fromJson(data as Map<String, dynamic>);
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
