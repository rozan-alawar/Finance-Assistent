import '../entities/expense.dart';
import '../repositories/expense_repository.dart';
import 'usecase.dart';

/// Use case to update an existing expense
class UpdateExpenseUseCase implements UseCase<ExpenseEntity, ExpenseEntity> {
  final ExpenseRepository repository;

  UpdateExpenseUseCase(this.repository);

  @override
  Future<ExpenseEntity> call(ExpenseEntity expense) async {
    return await repository.updateExpense(expense);
  }
}
