import '../entities/expense.dart';
import '../repositories/expense_repository.dart';
import 'usecase.dart';

/// Use case to add a new expense
class AddExpenseUseCase implements UseCase<ExpenseEntity, ExpenseEntity> {
  final ExpenseRepository repository;

  AddExpenseUseCase(this.repository);

  @override
  Future<ExpenseEntity> call(ExpenseEntity expense) async {
    return await repository.addExpense(expense);
  }
}
