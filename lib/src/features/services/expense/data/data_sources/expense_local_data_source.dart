import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/expense_category.dart';
import '../models/category_breakdown_model.dart';
import '../models/donut_chart_model.dart';
import '../models/expense_model.dart';
import '../models/expense_overview_model.dart';

/// Local data source for expense operations using SharedPreferences
abstract class ExpenseLocalDataSource {
  Future<List<ExpenseModel>> getExpenses();
  Future<void> saveExpenses(List<ExpenseModel> expenses);
  Future<ExpenseModel> addExpense(ExpenseModel expense);
  Future<ExpenseModel> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(String id);

  /// Get expenses filtered by date range
  Future<List<ExpenseModel>> getExpensesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get expenses filtered by category
  Future<List<ExpenseModel>> getExpensesByCategory(String category);

  /// Compute overview from stored expenses
  Future<ExpenseOverviewModel> getExpensesOverview({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Compute categories breakdown from stored expenses
  Future<CategoriesBreakdownResponse> getCategoriesBreakdown({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Compute donut chart data from stored expenses
  Future<DonutChartResponse> getDonutChartData({
    DateTime? startDate,
    DateTime? endDate,
  });
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _expensesKey = 'expenses';
  static const String _expensesInitialized = 'expenses_initialized';

  ExpenseLocalDataSourceImpl({required this.sharedPreferences}) {
    _initSeedData();
  }

  /// Seed initial expense data if first time
  void _initSeedData() {
    if (sharedPreferences.getBool(_expensesInitialized) == true) return;

    final now = DateTime.now();
    final seedExpenses = <Map<String, dynamic>>[
      {
        'id': 'exp_1',
        'name': 'Grocery Shopping',
        'amount': 85.50,
        'dueDate': now.subtract(const Duration(days: 1)).toIso8601String().split('T')[0],
        'category': 'FOOD',
      },
      {
        'id': 'exp_2',
        'name': 'Uber Ride',
        'amount': 22.00,
        'dueDate': now.subtract(const Duration(days: 2)).toIso8601String().split('T')[0],
        'category': 'TRANSPORT',
      },
      {
        'id': 'exp_3',
        'name': 'Netflix Subscription',
        'amount': 15.99,
        'dueDate': now.subtract(const Duration(days: 3)).toIso8601String().split('T')[0],
        'category': 'ENTERTAINMENT',
      },
      {
        'id': 'exp_4',
        'name': 'Rent Payment',
        'amount': 1200.00,
        'dueDate': now.subtract(const Duration(days: 5)).toIso8601String().split('T')[0],
        'category': 'HOUSING',
      },
      {
        'id': 'exp_5',
        'name': 'Doctor Visit',
        'amount': 75.00,
        'dueDate': now.subtract(const Duration(days: 7)).toIso8601String().split('T')[0],
        'category': 'HEALTH',
      },
      {
        'id': 'exp_6',
        'name': 'Restaurant Lunch',
        'amount': 32.50,
        'dueDate': now.subtract(const Duration(days: 1)).toIso8601String().split('T')[0],
        'category': 'FOOD',
      },
      {
        'id': 'exp_7',
        'name': 'Gas Station',
        'amount': 45.00,
        'dueDate': now.subtract(const Duration(days: 4)).toIso8601String().split('T')[0],
        'category': 'TRANSPORT',
      },
      {
        'id': 'exp_8',
        'name': 'Gym Membership',
        'amount': 50.00,
        'dueDate': now.subtract(const Duration(days: 10)).toIso8601String().split('T')[0],
        'category': 'HEALTH',
      },
    ];

    sharedPreferences.setString(_expensesKey, json.encode(seedExpenses));
    sharedPreferences.setBool(_expensesInitialized, true);
  }

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    final jsonString = sharedPreferences.getString(_expensesKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((json) => ExpenseModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveExpenses(List<ExpenseModel> expenses) async {
    final jsonList = expenses.map((e) => e.toJson()).toList();
    await sharedPreferences.setString(_expensesKey, json.encode(jsonList));
  }

  @override
  Future<ExpenseModel> addExpense(ExpenseModel expense) async {
    final expenses = await getExpenses();
    // Generate ID if empty
    final newExpense = expense.id.isEmpty
        ? ExpenseModel(
            id: 'exp_${DateTime.now().millisecondsSinceEpoch}',
            name: expense.name,
            amount: expense.amount,
            date: expense.date,
            category: expense.category,
          )
        : expense;
    expenses.insert(0, newExpense);
    await saveExpenses(expenses);
    return newExpense;
  }

  @override
  Future<ExpenseModel> updateExpense(ExpenseModel expense) async {
    final expenses = await getExpenses();
    final index = expenses.indexWhere((e) => e.id == expense.id);

    if (index != -1) {
      expenses[index] = expense;
      await saveExpenses(expenses);
    }

    return expense;
  }

  @override
  Future<void> deleteExpense(String id) async {
    final expenses = await getExpenses();
    expenses.removeWhere((e) => e.id == id);
    await saveExpenses(expenses);
  }

  @override
  Future<List<ExpenseModel>> getExpensesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final expenses = await getExpenses();
    return expenses.where((e) {
      return !e.date.isBefore(startDate) && !e.date.isAfter(endDate);
    }).toList();
  }

  @override
  Future<List<ExpenseModel>> getExpensesByCategory(String category) async {
    final expenses = await getExpenses();
    return expenses
        .where((e) => e.category.id.toLowerCase() == category.toLowerCase())
        .toList();
  }

  @override
  Future<ExpenseOverviewModel> getExpensesOverview({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    List<ExpenseModel> expenses;
    if (startDate != null && endDate != null) {
      expenses = await getExpensesByDateRange(
        startDate: startDate,
        endDate: endDate,
      );
    } else {
      expenses = await getExpenses();
    }

    double totalExpenses = 0;
    for (final e in expenses) {
      totalExpenses += e.amount;
    }

    // Simulate some overview values
    return ExpenseOverviewModel(
      totalBalance: 5000.00 - totalExpenses,
      income: 5000.00,
      expenses: totalExpenses,
      percentageChange: expenses.isNotEmpty ? -12.5 : 0.0,
    );
  }

  @override
  Future<CategoriesBreakdownResponse> getCategoriesBreakdown({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    List<ExpenseModel> expenses;
    if (startDate != null && endDate != null) {
      expenses = await getExpensesByDateRange(
        startDate: startDate,
        endDate: endDate,
      );
    } else {
      expenses = await getExpenses();
    }

    // Group by category
    final Map<String, double> categoryTotals = {};
    double totalAmount = 0;
    for (final e in expenses) {
      final catId = e.category.id.toUpperCase();
      categoryTotals[catId] = (categoryTotals[catId] ?? 0) + e.amount;
      totalAmount += e.amount;
    }

    final categories = categoryTotals.entries.map((entry) {
      final category = ExpenseCategory.fromId(entry.key);
      return CategoryBreakdownModel(
        categoryId: entry.key,
        categoryName: category.name,
        amount: entry.value,
        percentage: totalAmount > 0 ? (entry.value / totalAmount) * 100 : 0,
      );
    }).toList();

    // Sort by amount descending
    categories.sort((a, b) => b.amount.compareTo(a.amount));

    return CategoriesBreakdownResponse(
      categories: categories,
      totalExpenses: totalAmount,
    );
  }

  @override
  Future<DonutChartResponse> getDonutChartData({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    List<ExpenseModel> expenses;
    if (startDate != null && endDate != null) {
      expenses = await getExpensesByDateRange(
        startDate: startDate,
        endDate: endDate,
      );
    } else {
      expenses = await getExpenses();
    }

    // Group by category
    final Map<String, double> categoryTotals = {};
    double totalAmount = 0;
    for (final e in expenses) {
      final catId = e.category.id.toUpperCase();
      categoryTotals[catId] = (categoryTotals[catId] ?? 0) + e.amount;
      totalAmount += e.amount;
    }

    final items = categoryTotals.entries.map((entry) {
      final category = ExpenseCategory.fromId(entry.key);
      return DonutChartItemModel(
        categoryId: entry.key,
        categoryName: category.name,
        amount: entry.value,
        percentage: totalAmount > 0 ? (entry.value / totalAmount) * 100 : 0,
        color: '#${category.color.value.toRadixString(16).substring(2)}',
      );
    }).toList();

    items.sort((a, b) => b.amount.compareTo(a.amount));

    return DonutChartResponse(
      items: items,
      totalAmount: totalAmount,
    );
  }
}
