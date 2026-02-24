import '../../../../core/network/api_endpoints.dart';
import '../../../../core/services/network/main_service/network_service.dart';
import '../models/budget_data_model.dart';
import '../models/budget_model.dart';
import '../models/chart_model/budget_chart_data_model.dart';
import '../models/chart_model/chart_data_model.dart';

abstract class BudgetRemoteDatasource {
  Future<List<BudgetDataModel>> getBudgets();
  Future<List<ChartDataModel>> getChartData();
}

class BudgetRemoteDataSourceImpl implements BudgetRemoteDatasource {
  const BudgetRemoteDataSourceImpl(this.networkService);

  final NetworkService networkService;

  @override
  Future<List<BudgetDataModel>> getBudgets() async {
    final response = await networkService.get<Map<String, dynamic>>(
      path: ApiEndpoints.budgets,
    );

    if (response.statusCode == 200) {
      final budgetModel = BudgetModel.fromJson(response.data!);
      return budgetModel.data ?? [];
    } else {
      throw Exception('Failed to load budgets');
    }
  }

  @override
  Future<List<ChartDataModel>> getChartData() async {
    final response = await networkService.get<Map<String, dynamic>>(
      path: ApiEndpoints.chartData,
    );

    if (response.statusCode == 200) {
      final budgetChartModel = BudgetChartDataModel.fromJson(response.data!);
      return budgetChartModel.data ?? [];
    } else {
      throw Exception('Failed to load chart data');
    }
  }
}
