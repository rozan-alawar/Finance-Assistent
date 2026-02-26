import '../entity/budget_data.dart';
import '../entity/budget_summary.dart';

abstract class BudgetRepository {
  Future<List<BudgetData>> getBudgets();
  Future<BudgetSummary> getSummary();
}
