import '../../../../core/network/api_endpoints.dart';
import '../../../../core/services/network/main_service/network_service.dart';
import '../models/suggest_budget_models/budget_chart_data_model.dart';
import '../models/suggest_budget_models/chart_data_model.dart';

abstract class AiChatRemoteDatasource {
  Future<List<ChartDataModel>> getChartData();
}

class AiChatRemoteDataSourceImpl implements AiChatRemoteDatasource {
  const AiChatRemoteDataSourceImpl(this.networkService);

  final NetworkService networkService;

  @override
  Future<List<ChartDataModel>> getChartData() async {
    final response = await networkService.get<Map<String, dynamic>>(
      path: ApiEndpoints.suggestBudget,
    );

    if (response.statusCode == 200) {
      final budgetChartModel = BudgetChartDataModel.fromJson(response.data!);
      return budgetChartModel.data ?? [];
    } else {
      throw Exception('Failed to load chart data');
    }
  }
}
