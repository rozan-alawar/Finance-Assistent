import 'package:finance_assistent/src/core/services/network/main_service/network_service.dart';
import 'package:finance_assistent/src/features/income/data/model/income_model.dart';
import 'package:finance_assistent/src/features/income/data/model/income_summary_model.dart';

class IncomeRemoteDataSource {
  final NetworkService mainApiFacade;

  IncomeRemoteDataSource(this.mainApiFacade);
  String get incomSummaryPath => '/incomes/summary';
  String get getIncomsPath => '/incomes';

  Future<void> createIncome(Map<String, dynamic> body) async {
    final response = await mainApiFacade.post<Map<String, dynamic>>(
      path: getIncomsPath,
      data: body,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create income');
    }
  }

  Future<IncomeSummaryModel> getSummary() async {
    final response = await mainApiFacade.get<Map<String, dynamic>>(
      path: incomSummaryPath,
    );

    if (response.statusCode == 200 &&
        response.data != null &&
        response.data!['success'] == true) {
      return IncomeSummaryModel.fromJson(response.data!['data']);
    } else {
      throw Exception('Failed to load income summary');
    }
  }

  Future<IncomeListResponse> getIncomes({int page = 1, int limit = 10}) async {
    final response = await mainApiFacade.get<Map<String, dynamic>>(
      path: getIncomsPath,
      queryParameters: {'page': page, 'limit': limit},
    );

    if (response.statusCode == 200 &&
        response.data != null &&
        response.data!['success'] == true) {
      return IncomeListResponse.fromJson(response.data!);
    } else {
      throw Exception('Failed to load incomes');
    }
  }
}
