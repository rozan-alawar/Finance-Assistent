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

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'chartDataList': chartDataList
          ?.map(
            (item) => {
              'category': item.category,
              'amount': item.amount,
              'percentage': item.percentage,
            },
          )
          .toList(),
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    final chartDataRaw = map['chartDataList'] as List?;
    return ChatMessage(
      message: map['message']?.toString() ?? '',
      isUser: map['isUser'] == true,
      timestamp: DateTime.tryParse(map['timestamp']?.toString() ?? ''),
      chartDataList: chartDataRaw
          ?.whereType<Map>()
          .map(
            (item) => ChartData(
              category: item['category']?.toString(),
              amount: item['amount'] is num
                  ? (item['amount'] as num).toInt()
                  : null,
              percentage: item['percentage'] is num
                  ? (item['percentage'] as num).toInt()
                  : null,
            ),
          )
          .toList(),
    );
  }
}
