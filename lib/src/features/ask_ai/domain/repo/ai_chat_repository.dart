import '../entities/chart_data.dart';

abstract class AiChatRepository {
  Future<List<ChartData>> getChartData();
}
