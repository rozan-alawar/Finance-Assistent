import '../entity/budget_summary.dart';
import '../repo/budget_repository.dart';

class GetBudgetSummaryUsecase {
  final BudgetRepository repository;

  GetBudgetSummaryUsecase(this.repository);

  Future<BudgetSummary> call() async {
    return await repository.getSummary();
  }
}
