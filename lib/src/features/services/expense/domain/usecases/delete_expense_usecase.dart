import '../repositories/expense_repository.dart';
import 'usecase.dart';

/// Use case to delete an expense by id
class DeleteExpenseUseCase implements UseCase<void, String> {
  final ExpenseRepository repository;

  DeleteExpenseUseCase(this.repository);

  @override
  Future<void> call(String id) async {
    await repository.deleteExpense(id);
  }
}
