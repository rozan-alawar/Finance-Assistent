import '../entity/income_summary.dart';
import '../repo/budget_repository.dart';

class GetTotalIncomeUseCase {
  final BudgetRepository repository;

  GetTotalIncomeUseCase(this.repository);

  Future<IncomeSummary> call() async {
    return repository.getTotalIncome();
  }
}
