import '../entities/expense.dart';
import '../entities/expense_category.dart';
import '../repositories/expense_repository.dart';
import 'usecase.dart';

/// Use case to get expenses filtered by category
class GetExpensesByCategoryUseCase
    implements UseCase<List<ExpenseEntity>, ExpenseCategory> {
  final ExpenseRepository repository;

  GetExpensesByCategoryUseCase(this.repository);

  @override
  Future<List<ExpenseEntity>> call(ExpenseCategory category) async {
    return await repository.getExpensesByCategory(category);
  }
}
