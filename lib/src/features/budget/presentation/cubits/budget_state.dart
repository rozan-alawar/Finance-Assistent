import '../../domain/entity/budget_data.dart';
import '../../domain/entity/budget_summary.dart';

abstract class BudgetState {}

class InitialBudgetState extends BudgetState {}

class BudgetLoadingState extends BudgetState {}

class BudgetLoadedState extends BudgetState {
  final List<BudgetData> budgets;
  BudgetLoadedState(this.budgets);
}

class BudgetSummaryLoadedState extends BudgetState {
  final BudgetSummary summary;
  BudgetSummaryLoadedState(this.summary);
}

class BudgetSummaryLoadingState extends BudgetState {}

class BudgetSummaryErrorState extends BudgetState {
  final String exception;
  BudgetSummaryErrorState(this.exception);
}

class BudgetErrorState extends BudgetState {
  final String exception;
  BudgetErrorState(this.exception);
}
