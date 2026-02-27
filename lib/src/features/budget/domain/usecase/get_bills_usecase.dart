import '../entity/bill_data.dart';
import '../repo/budget_repository.dart';

class GetBillsUseCase {
  final BudgetRepository repository;

  GetBillsUseCase(this.repository);

  Future<List<BillData>> call() async {
    return await repository.getBills();
  }
}
