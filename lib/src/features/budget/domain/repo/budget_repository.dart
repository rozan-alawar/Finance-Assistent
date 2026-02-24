import '../entity/budget_data.dart';
import '../entity/chart_data.dart';

abstract class BudgetRepository {
  Future<List<BudgetData>> getBudgets();
  Future<List<ChartData>> getChartData();
}
