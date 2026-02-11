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

  /// Set to false when real APIs are ready
  static const bool _useMockData = true;

  ExpenseRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  // ============ MOCK DATA ============

  static final List<ExpenseEntity> _mockExpenses = [
    ExpenseEntity(
      id: '1',
      name: 'Grocery Shopping',
      amount: 85.50,
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: ExpenseCategory.food,
    ),
    ExpenseEntity(
      id: '2',
      name: 'Uber Ride',
      amount: 24.00,
      date: DateTime.now().subtract(const Duration(days: 2)),
      category: ExpenseCategory.transport,
    ),
    ExpenseEntity(
      id: '3',
      name: 'Netflix Subscription',
      amount: 15.99,
      date: DateTime.now().subtract(const Duration(days: 3)),
      category: ExpenseCategory.entertainment,
    ),
    ExpenseEntity(
      id: '4',
      name: 'Doctor Visit',
      amount: 120.00,
      date: DateTime.now().subtract(const Duration(days: 5)),
      category: ExpenseCategory.health,
    ),
    ExpenseEntity(
      id: '5',
      name: 'Electricity Bill',
      amount: 75.00,
      date: DateTime.now().subtract(const Duration(days: 7)),
      category: ExpenseCategory.housing,
    ),
    ExpenseEntity(
      id: '6',
      name: 'Restaurant Dinner',
      amount: 45.00,
      date: DateTime.now().subtract(const Duration(days: 4)),
      category: ExpenseCategory.food,
    ),
    ExpenseEntity(
      id: '7',
      name: 'Bus Pass',
      amount: 30.00,
      date: DateTime.now().subtract(const Duration(days: 6)),
      category: ExpenseCategory.transport,
    ),
    ExpenseEntity(
      id: '8',
      name: 'Phone Accessories',
      amount: 19.99,
      date: DateTime.now().subtract(const Duration(days: 8)),
      category: ExpenseCategory.others,
    ),
  ];

  // Keep a mutable copy for add/delete operations
  final List<ExpenseEntity> _expenses = List.from(_mockExpenses);

  ExpenseOverviewModel get _mockOverview {
    double total = 0;
    for (final e in _expenses) {
      total += e.amount;
    }
    return ExpenseOverviewModel(
      totalBalance: 31296.0,
      income: 5200.0,
      expenses: total,
      percentageChange: -12.5,
    );
  }

  CategoriesBreakdownResponse get _mockBreakdown {
    final Map<ExpenseCategory, double> categoryTotals = {};
    double totalExpenses = 0;
    for (final expense in _expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
      totalExpenses += expense.amount;
    }

    final categories = categoryTotals.entries.map((entry) {
      return CategoryBreakdownModel(
        categoryId: entry.key.id,
        categoryName: entry.key.name,
        amount: entry.value,
        percentage:
            totalExpenses > 0 ? (entry.value / totalExpenses) * 100 : 0,
      );
    }).toList();

    return CategoriesBreakdownResponse(
      categories: categories,
      totalExpenses: totalExpenses,
    );
  }

  DonutChartResponse get _mockDonutChart {
    final Map<ExpenseCategory, double> categoryTotals = {};
    double totalAmount = 0;
    for (final expense in _expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
      totalAmount += expense.amount;
    }

    final items = categoryTotals.entries.map((entry) {
      return DonutChartItemModel(
        categoryId: entry.key.id,
        categoryName: entry.key.name,
        amount: entry.value,
        percentage: totalAmount > 0 ? (entry.value / totalAmount) * 100 : 0,
        color: '#${entry.key.color.value.toRadixString(16).substring(2)}',
      );
    }).toList();

    return DonutChartResponse(
      items: items,
      totalAmount: totalAmount,
    );
  }

  // ============ REPOSITORY METHODS ============

  @override
  Future<ExpenseOverviewModel> getExpensesOverview({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      return _mockOverview;
    }
    return await remoteDataSource.getExpensesOverview(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<CategoriesBreakdownResponse> getCategoriesBreakdown({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 200));
      return _mockBreakdown;
    }
    return await remoteDataSource.getCategoriesBreakdown(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<DonutChartResponse> getDonutChartData({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 200));
      return _mockDonutChart;
    }
    return await remoteDataSource.getDonutChartData(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<List<ExpenseEntity>> getExpenses() async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      return List.from(_expenses);
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
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 200));
      return _expenses.where((e) {
        return !e.date.isBefore(startDate) && !e.date.isAfter(endDate);
      }).toList();
    }
    return await remoteDataSource.getExpenses(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<List<ExpenseEntity>> getExpensesByCategory(
    ExpenseCategory category,
  ) async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 200));
      return _expenses.where((e) => e.category == category).toList();
    }
    return await remoteDataSource.getExpenses(categoryId: category.id);
  }

  @override
  Future<ExpenseEntity> addExpense(ExpenseEntity expense) async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      _expenses.insert(0, expense);
      return expense;
    }
    final model = ExpenseModel.fromEntity(expense);
    final createdExpense = await remoteDataSource.createExpense(model);
    await localDataSource.addExpense(createdExpense);
    return createdExpense;
  }

  @override
  Future<ExpenseEntity> updateExpense(ExpenseEntity expense) async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 200));
      final index = _expenses.indexWhere((e) => e.id == expense.id);
      if (index != -1) {
        _expenses[index] = expense;
      }
      return expense;
    }
    final model = ExpenseModel.fromEntity(expense);
    return await localDataSource.updateExpense(model);
  }

  @override
  Future<void> deleteExpense(String id) async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 200));
      _expenses.removeWhere((e) => e.id == id);
      return;
    }
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
