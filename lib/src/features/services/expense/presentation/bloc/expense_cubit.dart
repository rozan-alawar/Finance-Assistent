import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_category.dart';
import '../../domain/repositories/expense_repository.dart';
import 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  final ExpenseRepository repository;

  ExpenseCubit({required this.repository}) : super(const ExpenseInitial());

  /// Load expenses with optional date filter
  Future<void> loadExpenses({
    DateFilterType dateFilter = DateFilterType.month,
    DateTime? selectedDate,
  }) async {
    emit(const ExpenseLoading());

    try {
      final date = selectedDate ?? DateTime.now();
      final dateRange = _getDateRange(dateFilter, date);

      // Fetch data from API endpoints
      final overviewFuture = repository.getExpensesOverview(
        startDate: dateRange.$1,
        endDate: dateRange.$2,
      );
      final breakdownFuture = repository.getCategoriesBreakdown(
        startDate: dateRange.$1,
        endDate: dateRange.$2,
      );
      final expensesFuture = repository.getExpensesByDateRange(
        startDate: dateRange.$1,
        endDate: dateRange.$2,
      );

      // Execute all API calls in parallel
      final results = await Future.wait([
        overviewFuture,
        breakdownFuture,
        expensesFuture,
      ]);

      final overview = results[0] as dynamic;
      final breakdown = results[1] as dynamic;
      final expenses = results[2] as List<ExpenseEntity>;

      emit(
        ExpenseLoaded(
          expenses: expenses,
          totalExpenses: overview.expenses,
          totalIncome: overview.income,
          percentageChangeValue: overview.percentageChange,
          dateFilter: dateFilter,
          selectedDate: date,
          expensesByCategory: breakdown.toExpensesByCategoryMap(),
        ),
      );
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  /// Change date filter (Day/Week/Month/Year)
  Future<void> changeDateFilter(DateFilterType filter) async {
    final currentState = state;
    if (currentState is ExpenseLoaded) {
      await loadExpenses(
        dateFilter: filter,
        selectedDate: currentState.selectedDate,
      );
    }
  }

  /// Navigate to previous period
  Future<void> previousPeriod() async {
    final currentState = state;
    if (currentState is ExpenseLoaded) {
      final newDate = _getPreviousDate(
        currentState.dateFilter,
        currentState.selectedDate,
      );
      await loadExpenses(
        dateFilter: currentState.dateFilter,
        selectedDate: newDate,
      );
    }
  }

  /// Navigate to next period
  Future<void> nextPeriod() async {
    final currentState = state;
    if (currentState is ExpenseLoaded) {
      final newDate = _getNextDate(
        currentState.dateFilter,
        currentState.selectedDate,
      );
      await loadExpenses(
        dateFilter: currentState.dateFilter,
        selectedDate: newDate,
      );
    }
  }

  /// Toggle category expansion
  void toggleCategoryExpansion(ExpenseCategory category) {
    final currentState = state;
    if (currentState is ExpenseLoaded) {
      if (currentState.expandedCategory == category) {
        emit(currentState.copyWith(clearExpandedCategory: true));
      } else {
        emit(currentState.copyWith(expandedCategory: category));
      }
    }
  }

  /// Add a new expense
  Future<void> addExpense(ExpenseEntity expense) async {
    try {
      await repository.addExpense(expense);

      // Reload expenses to refresh the list
      final currentState = state;
      if (currentState is ExpenseLoaded) {
        await loadExpenses(
          dateFilter: currentState.dateFilter,
          selectedDate: currentState.selectedDate,
        );
      } else {
        await loadExpenses();
      }
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  /// Delete an expense
  Future<void> deleteExpense(String id) async {
    try {
      await repository.deleteExpense(id);

      // Reload expenses to refresh the list
      final currentState = state;
      if (currentState is ExpenseLoaded) {
        await loadExpenses(
          dateFilter: currentState.dateFilter,
          selectedDate: currentState.selectedDate,
        );
      }
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  // Helper methods

  /// Get date range based on filter type
  (DateTime, DateTime) _getDateRange(DateFilterType filter, DateTime date) {
    switch (filter) {
      case DateFilterType.day:
        final start = DateTime(date.year, date.month, date.day);
        final end = start
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1));
        return (start, end);

      case DateFilterType.week:
        final weekDay = date.weekday;
        final start = date.subtract(Duration(days: weekDay - 1));
        final end = start.add(const Duration(days: 6));
        return (
          DateTime(start.year, start.month, start.day),
          DateTime(end.year, end.month, end.day, 23, 59, 59),
        );

      case DateFilterType.month:
        final start = DateTime(date.year, date.month, 1);
        final end = DateTime(date.year, date.month + 1, 0, 23, 59, 59);
        return (start, end);

      case DateFilterType.year:
        final start = DateTime(date.year, 1, 1);
        final end = DateTime(date.year, 12, 31, 23, 59, 59);
        return (start, end);
    }
  }

  /// Get previous date based on filter
  DateTime _getPreviousDate(DateFilterType filter, DateTime date) {
    switch (filter) {
      case DateFilterType.day:
        return date.subtract(const Duration(days: 1));
      case DateFilterType.week:
        return date.subtract(const Duration(days: 7));
      case DateFilterType.month:
        return DateTime(date.year, date.month - 1, date.day);
      case DateFilterType.year:
        return DateTime(date.year - 1, date.month, date.day);
    }
  }

  /// Get next date based on filter
  DateTime _getNextDate(DateFilterType filter, DateTime date) {
    switch (filter) {
      case DateFilterType.day:
        return date.add(const Duration(days: 1));
      case DateFilterType.week:
        return date.add(const Duration(days: 7));
      case DateFilterType.month:
        return DateTime(date.year, date.month + 1, date.day);
      case DateFilterType.year:
        return DateTime(date.year + 1, date.month, date.day);
    }
  }
}

/// Cubit for Add Expense screen
class AddExpenseCubit extends Cubit<AddExpenseState> {
  final ExpenseRepository repository;

  AddExpenseCubit({required this.repository})
    : super(AddExpenseState(selectedDate: DateTime.now()));

  void updateName(String name) {
    emit(state.copyWith(name: name, clearError: true));
  }

  void updateAmount(double amount) {
    emit(state.copyWith(amount: amount, clearError: true));
  }

  void selectCategory(ExpenseCategory category) {
    emit(state.copyWith(selectedCategory: category));
  }

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  Future<bool> saveExpense() async {
    if (!state.isValid) {
      emit(state.copyWith(error: 'Please fill all required fields'));
      return false;
    }

    emit(state.copyWith(isLoading: true));

    try {
      final expense = ExpenseEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: state.name,
        amount: state.amount,
        date: state.selectedDate,
        category: state.selectedCategory,
      );

      await repository.addExpense(expense);
      emit(state.copyWith(isLoading: false));
      return true;
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
      return false;
    }
  }

  void reset() {
    emit(AddExpenseState(selectedDate: DateTime.now()));
  }
}
