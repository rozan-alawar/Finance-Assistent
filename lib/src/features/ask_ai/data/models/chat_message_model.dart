import '../../domain/entities/chart_data.dart';

class ChatMessage {
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final List<ChartData>? chartDataList;

  ChatMessage({
    required this.message,
    required this.isUser,
    DateTime? timestamp,
    this.chartDataList,
  }) : timestamp = timestamp ?? DateTime.now();
}
