import '../repositories/expense_repository.dart';
import 'usecase.dart';
import 'get_expenses_by_date_range_usecase.dart';

/// Use case to get total expenses amount
class GetTotalExpensesUseCase implements UseCaseNoParams<double> {
  final ExpenseRepository repository;

  GetTotalExpensesUseCase(this.repository);

  @override
  Future<double> call() async {
    return await repository.getTotalExpenses();
  }
}

/// Use case to get total expenses for a specific date range
class GetTotalExpensesByDateRangeUseCase
    implements UseCase<double, DateRangeParams> {
  final ExpenseRepository repository;

  GetTotalExpensesByDateRangeUseCase(this.repository);

  @override
  Future<double> call(DateRangeParams params) async {
    return await repository.getTotalExpensesByDateRange(
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}
