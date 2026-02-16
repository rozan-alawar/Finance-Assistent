import '../entities/expense.dart';
import '../entities/expense_category.dart';
import '../../data/models/expense_overview_model.dart';
import '../../data/models/category_breakdown_model.dart';
import '../../data/models/donut_chart_model.dart';

/// Abstract repository interface for expense operations
abstract class ExpenseRepository {
  /// Get expenses overview (total balance, income, expenses, percentage change)
  Future<ExpenseOverviewModel> getExpensesOverview({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get expenses categories breakdown
  Future<CategoriesBreakdownResponse> getCategoriesBreakdown({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get donut chart data
  Future<DonutChartResponse> getDonutChartData({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get all expenses
  Future<List<ExpenseEntity>> getExpenses();

  /// Get expenses filtered by date range
  Future<List<ExpenseEntity>> getExpensesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get expenses filtered by category
  Future<List<ExpenseEntity>> getExpensesByCategory(ExpenseCategory category);

  /// Add a new expense
  Future<ExpenseEntity> addExpense(ExpenseEntity expense);

  /// Update an existing expense
  Future<ExpenseEntity> updateExpense(ExpenseEntity expense);

  /// Delete an expense by id
  Future<void> deleteExpense(String id);

  /// Get total expenses amount
  Future<double> getTotalExpenses();

  /// Get total expenses for a specific date range
  Future<double> getTotalExpensesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  });
}
