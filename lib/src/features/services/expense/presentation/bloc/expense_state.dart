import 'package:equatable/equatable.dart';

import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_category.dart';

/// Date filter type for expense list
enum DateFilterType { day, week, month, year }

/// Base state class for Expense feature
abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the screen is first loaded
class ExpenseInitial extends ExpenseState {
  const ExpenseInitial();
}

/// Loading state while fetching data
class ExpenseLoading extends ExpenseState {
  const ExpenseLoading();
}

/// State when expenses are successfully loaded
class ExpenseLoaded extends ExpenseState {
  final List<ExpenseEntity> expenses;
  final double totalExpenses;
  final double totalIncome;
  final double percentageChangeValue;
  final DateFilterType dateFilter;
  final DateTime selectedDate;
  final Map<ExpenseCategory, double> expensesByCategory;
  final ExpenseCategory? expandedCategory;

  const ExpenseLoaded({
    required this.expenses,
    required this.totalExpenses,
    this.totalIncome = 0.0,
    this.percentageChangeValue = 0.0,
    required this.dateFilter,
    required this.selectedDate,
    required this.expensesByCategory,
    this.expandedCategory,
  });

  /// Get percentage change from API response
  double get percentageChange => percentageChangeValue;

  /// Get expenses for a specific category
  List<ExpenseEntity> getExpensesForCategory(ExpenseCategory category) {
    return expenses.where((e) => e.category == category).toList();
  }

  /// Create a copy with updated fields
  ExpenseLoaded copyWith({
    List<ExpenseEntity>? expenses,
    double? totalExpenses,
    double? totalIncome,
    double? percentageChangeValue,
    DateFilterType? dateFilter,
    DateTime? selectedDate,
    Map<ExpenseCategory, double>? expensesByCategory,
    ExpenseCategory? expandedCategory,
    bool clearExpandedCategory = false,
  }) {
    return ExpenseLoaded(
      expenses: expenses ?? this.expenses,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      totalIncome: totalIncome ?? this.totalIncome,
      percentageChangeValue: percentageChangeValue ?? this.percentageChangeValue,
      dateFilter: dateFilter ?? this.dateFilter,
      selectedDate: selectedDate ?? this.selectedDate,
      expensesByCategory: expensesByCategory ?? this.expensesByCategory,
      expandedCategory: clearExpandedCategory
          ? null
          : (expandedCategory ?? this.expandedCategory),
    );
  }

  @override
  List<Object?> get props => [
    expenses,
    totalExpenses,
    totalIncome,
    percentageChangeValue,
    dateFilter,
    selectedDate,
    expensesByCategory,
    expandedCategory,
  ];
}

/// Error state when something goes wrong
class ExpenseError extends ExpenseState {
  final String message;

  const ExpenseError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State for Add Expense screen
class AddExpenseState extends Equatable {
  final String name;
  final double amount;
  final ExpenseCategory selectedCategory;
  final DateTime selectedDate;
  final bool isLoading;
  final String? error;

  const AddExpenseState({
    this.name = '',
    this.amount = 0.0,
    this.selectedCategory = ExpenseCategory.food,
    required this.selectedDate,
    this.isLoading = false,
    this.error,
  });

  bool get isValid => name.isNotEmpty && amount > 0;

  AddExpenseState copyWith({
    String? name,
    double? amount,
    ExpenseCategory? selectedCategory,
    DateTime? selectedDate,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return AddExpenseState(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedDate: selectedDate ?? this.selectedDate,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
    name,
    amount,
    selectedCategory,
    selectedDate,
    isLoading,
    error,
  ];
}
