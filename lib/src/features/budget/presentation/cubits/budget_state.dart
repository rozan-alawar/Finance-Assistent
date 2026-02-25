import '../../domain/entity/budget_data.dart';

abstract class BudgetState {}

class InitialBudgetState extends BudgetState {}

class BudgetLoadingState extends BudgetState {}

class BudgetLoadedState extends BudgetState {
  final List<BudgetData> budgets;
  BudgetLoadedState(this.budgets);
}

class BudgetErrorState extends BudgetState {
  final String exception;
  BudgetErrorState(this.exception);
}
