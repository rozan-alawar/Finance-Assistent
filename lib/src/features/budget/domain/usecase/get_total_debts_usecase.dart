import '../entity/debts_summary.dart';
import '../repo/budget_repository.dart';

class GetTotalDebtsUsecase {
  final BudgetRepository repository;

  GetTotalDebtsUsecase(this.repository);

  Future<DebtsSummary> call() async {
    return repository.getTotalDebts();
  }
}
