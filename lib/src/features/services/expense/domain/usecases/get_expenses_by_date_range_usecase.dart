import '../entities/expense.dart';
import '../repositories/expense_repository.dart';
import 'usecase.dart';

/// Parameters for GetExpensesByDateRangeUseCase
class DateRangeParams {
  final DateTime startDate;
  final DateTime endDate;

  const DateRangeParams({required this.startDate, required this.endDate});
}

/// Use case to get expenses filtered by date range
class GetExpensesByDateRangeUseCase
    implements UseCase<List<ExpenseEntity>, DateRangeParams> {
  final ExpenseRepository repository;

  GetExpensesByDateRangeUseCase(this.repository);

  @override
  Future<List<ExpenseEntity>> call(DateRangeParams params) async {
    return await repository.getExpensesByDateRange(
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}
