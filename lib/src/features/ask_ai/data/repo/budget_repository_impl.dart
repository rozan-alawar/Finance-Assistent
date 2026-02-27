import '../../domain/entities/chart_data.dart';
import '../../domain/repo/ai_chat_repository.dart';
import '../datasource/ai_chat_remote_datasource.dart';

class AiChatRepositoryImpl implements AiChatRepository {
  final AiChatRemoteDatasource remoteDatasource;

  AiChatRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<ChartData>> getChartData() async {
    final models = await remoteDatasource.getChartData();
    return models.map((e) => e.toEntity()).toList();
  }
}
