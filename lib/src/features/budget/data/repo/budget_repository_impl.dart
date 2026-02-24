import '../../domain/entity/budget_data.dart';
import '../../domain/entity/chart_data.dart';
import '../../domain/repo/budget_repository.dart';
import '../datasource/budget_remote_datasource.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetRemoteDatasource remoteDatasource;

  BudgetRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<BudgetData>> getBudgets() async {
    final models = await remoteDatasource.getBudgets();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<ChartData>> getChartData() async {
    final models = await remoteDatasource.getChartData();
    return models.map((e) => e.toEntity()).toList();
  }
}
