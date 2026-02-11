import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/expense_model.dart';

/// Local data source for expense operations using SharedPreferences
abstract class ExpenseLocalDataSource {
  Future<List<ExpenseModel>> getExpenses();
  Future<void> saveExpenses(List<ExpenseModel> expenses);
  Future<ExpenseModel> addExpense(ExpenseModel expense);
  Future<ExpenseModel> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(String id);
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _expensesKey = 'expenses';

  ExpenseLocalDataSourceImpl({required this.sharedPreferences});

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
    expenses.add(expense);
    await saveExpenses(expenses);
    return expense;
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
}
