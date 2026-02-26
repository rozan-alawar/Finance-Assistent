import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_category.dart';
import '../../domain/repositories/expense_repository.dart';
import '../data_sources/expense_local_data_source.dart';
import '../data_sources/expense_remote_data_source.dart';
import '../models/category_breakdown_model.dart';
import '../models/donut_chart_model.dart';
import '../models/expense_model.dart';
import '../models/expense_overview_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource remoteDataSource;
  final ExpenseLocalDataSource localDataSource;

  /// Set to true to use SharedPreferences, false for real API
  static const bool _useLocalStorage = true;

  ExpenseRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  /// Convert DateTime to ISO date string for API query params
  String _toDateString(DateTime date) => date.toIso8601String().split('T')[0];

  /// Map DateFilterType to API period string
  String _toPeriod(DateTime start, DateTime end) {
    final diff = end.difference(start).inDays;
    if (diff <= 1) return 'day';
    if (diff <= 7) return 'week';
    if (diff <= 31) return 'month';
    return 'year';
  }

  @override
  Future<ExpenseOverviewModel> getExpensesOverview({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (_useLocalStorage) {
      return await localDataSource.getExpensesOverview(
        startDate: startDate,
        endDate: endDate,
      );
    }
    return await remoteDataSource.getExpensesOverview(
      period: startDate != null && endDate != null
          ? _toPeriod(startDate, endDate)
          : null,
      month: startDate?.month,
      from: startDate != null ? _toDateString(startDate) : null,
      to: endDate != null ? _toDateString(endDate) : null,
    );
  }

  @override
  Future<CategoriesBreakdownResponse> getCategoriesBreakdown({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (_useLocalStorage) {
      return await localDataSource.getCategoriesBreakdown(
        startDate: startDate,
        endDate: endDate,
      );
    }
    return await remoteDataSource.getCategoriesBreakdown(
      period: startDate != null && endDate != null
          ? _toPeriod(startDate, endDate)
          : null,
      month: startDate?.month,
      from: startDate != null ? _toDateString(startDate) : null,
      to: endDate != null ? _toDateString(endDate) : null,
    );
  }

  @override
  Future<DonutChartResponse> getDonutChartData({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (_useLocalStorage) {
      return await localDataSource.getDonutChartData(
        startDate: startDate,
        endDate: endDate,
      );
    }
    return await remoteDataSource.getDonutChartData(
      period: startDate != null && endDate != null
          ? _toPeriod(startDate, endDate)
          : null,
      month: startDate?.month,
      from: startDate != null ? _toDateString(startDate) : null,
      to: endDate != null ? _toDateString(endDate) : null,
    );
  }

  @override
  Future<List<ExpenseEntity>> getExpenses() async {
    if (_useLocalStorage) {
      return await localDataSource.getExpenses();
    }
    final expenses = await remoteDataSource.getExpenses();
    await localDataSource.saveExpenses(expenses);
    return expenses;
  }

  @override
  Future<List<ExpenseEntity>> getExpensesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (_useLocalStorage) {
      return await localDataSource.getExpensesByDateRange(
        startDate: startDate,
        endDate: endDate,
      );
    }
    return await remoteDataSource.getExpenses(
      from: _toDateString(startDate),
      to: _toDateString(endDate),
    );
  }

  @override
  Future<List<ExpenseEntity>> getExpensesByCategory(
    ExpenseCategory category,
  ) async {
    if (_useLocalStorage) {
      return await localDataSource.getExpensesByCategory(
        category.id.toUpperCase(),
      );
    }
    return await remoteDataSource.getExpenses(
      category: category.id.toUpperCase(),
    );
  }

  @override
  Future<ExpenseEntity> addExpense(ExpenseEntity expense) async {
    final model = ExpenseModel.fromEntity(expense);
    if (_useLocalStorage) {
      return await localDataSource.addExpense(model);
    }
    final createdExpense = await remoteDataSource.createExpense(model);
    await localDataSource.addExpense(createdExpense);
    return createdExpense;
  }

  @override
  Future<ExpenseEntity> updateExpense(ExpenseEntity expense) async {
    final model = ExpenseModel.fromEntity(expense);
    return await localDataSource.updateExpense(model);
  }

  @override
  Future<void> deleteExpense(String id) async {
    await localDataSource.deleteExpense(id);
  }

  @override
  Future<double> getTotalExpenses() async {
    final expenses = await getExpenses();
    double total = 0;
    for (final e in expenses) {
      total += e.amount;
    }
    return total;
  }

  @override
  Future<double> getTotalExpensesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final expenses = await getExpensesByDateRange(
      startDate: startDate,
      endDate: endDate,
    );
    double total = 0;
    for (final e in expenses) {
      total += e.amount;
    }
    return total;
  }
}
