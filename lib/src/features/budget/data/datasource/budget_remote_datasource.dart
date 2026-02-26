import '../../../../core/network/api_endpoints.dart';
import '../../../../core/services/network/main_service/network_service.dart';
import '../models/budget_data_model.dart';
import '../models/budget_model.dart';
import '../models/budget_summary_model.dart';
import '../models/summary_data_model.dart';

abstract class BudgetRemoteDatasource {
  Future<List<BudgetDataModel>> getBudgets();
  Future<SummaryDataModel> getSummary();
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
  Future<SummaryDataModel> getSummary() async {
    final response = await networkService.get<Map<String, dynamic>>(
      path: ApiEndpoints.budgetSummary,
    );

    if (response.statusCode == 200) {
      final budgetSummaryModel = BudgetSummaryModel.fromJson(response.data!);
      return budgetSummaryModel.data!;
    } else {
      throw Exception('Failed to load budgets');
    }
  }
}
