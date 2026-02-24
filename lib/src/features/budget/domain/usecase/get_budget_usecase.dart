import '../entity/budget_data.dart';
import '../repo/budget_repository.dart';

class GetBudgetUsecase {
  final BudgetRepository repository;

  GetBudgetUsecase(this.repository);

  Future<List<BudgetData>> call() async {
    return await repository.getBudgets();
  }
}
