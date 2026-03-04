import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/exceptions/app_error_extension.dart';
import '../../../../core/services/network/main_service/network_service.dart';
import '../../../auth/domain/report_data_model.dart';

@immutable
class ReportsRemoteDataSource {
  const ReportsRemoteDataSource(this.mainApiFacade);

  final NetworkService mainApiFacade;

  String get reportsPath => '/user/reports';

  Future<ReportDataModel?> fetchReports({String? filterTime}) async {
    final dio = mainApiFacade.dio;

    try {
      final response = await dio.get<Map<String, dynamic>>(
        reportsPath,
        queryParameters: {
          if (filterTime != null)
            'time_filter': filterTime, // Day, Week, Month, Year
        },
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      final status = response.statusCode ?? 0;

      if (status == 401 || status == 403) {
        throw const UserFriendlyException(
          'Your session expired. Please sign in again.',
        );
      }

      if (status == 404 || status == 204) {
        return null;
      }
      if (status < 200 || status >= 300) {
        throw UserFriendlyException('Failed to load reports (HTTP $status).');
      }

      final root = response.data ?? const <String, dynamic>{};
      final dynamic data = root['data'];

      if (data == null || (data is List && data.isEmpty)) {
        return null;
      }

      return ReportDataMapper.fromMap(Map<String, dynamic>.from(data));
    } catch (e) {
      if (e is UserFriendlyException) rethrow;
      throw UserFriendlyException('Error fetching reports: $e');
    }
  }
}
