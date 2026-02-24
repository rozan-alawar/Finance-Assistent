import '../entity/chart_data.dart';
import '../repo/budget_repository.dart';

class GetChartDataUsecase {
  final BudgetRepository repository;

  GetChartDataUsecase(this.repository);

  Future<List<ChartData>> call() async {
    return await repository.getChartData();
  }
}
