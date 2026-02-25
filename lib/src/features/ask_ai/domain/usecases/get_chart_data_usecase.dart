import '../entities/chart_data.dart';
import '../repo/ai_chat_repository.dart';

class GetChartDataUsecase {
  final AiChatRepository repository;

  GetChartDataUsecase(this.repository);

  Future<List<ChartData>> call() async {
    return await repository.getChartData();
  }
}
