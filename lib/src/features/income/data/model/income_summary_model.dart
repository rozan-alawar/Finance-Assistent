class IncomeSummaryModel {
  final double totalIncome;
  final int count;

  IncomeSummaryModel({required this.totalIncome, required this.count});

  factory IncomeSummaryModel.fromJson(Map<String, dynamic> json) {
    return IncomeSummaryModel(
      totalIncome: double.tryParse(json['totalIncome'].toString()) ?? 0.0,
      count: json['count'] as int? ?? 0,
    );
  }
}
