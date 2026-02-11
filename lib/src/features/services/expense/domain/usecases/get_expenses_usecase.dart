import '../entities/expense.dart';
import '../repositories/expense_repository.dart';
import 'usecase.dart';

/// Use case to get all expenses
class GetExpensesUseCase implements UseCaseNoParams<List<ExpenseEntity>> {
  final ExpenseRepository repository;

  GetExpensesUseCase(this.repository);

  @override
  Future<List<ExpenseEntity>> call() async {
    return await repository.getExpenses();
  }
}
