import '../../domain/entity/budget_data.dart';
import '../../domain/entity/budget_summary.dart';
import '../../domain/entity/debts_summary.dart';
import '../../domain/entity/income_summary.dart';

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

class DebtsSummaryLoadingState extends BudgetState {}

class DebtsSummaryLoadedState extends BudgetState {
  final DebtsSummary debtsSummary;
  DebtsSummaryLoadedState(this.debtsSummary);
}

class DebtsSummaryErrorState extends BudgetState {
  final String exception;
  DebtsSummaryErrorState(this.exception);
}

class IncomeSummaryLoadingState extends BudgetState {}

class IncomeSummaryLoadedState extends BudgetState {
  final IncomeSummary incomeSummary;
  IncomeSummaryLoadedState(this.incomeSummary);
}

class IncomeSummaryErrorState extends BudgetState {
  final String exception;
  IncomeSummaryErrorState(this.exception);
}
