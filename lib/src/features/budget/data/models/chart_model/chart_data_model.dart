import '../../../domain/entity/chart_data.dart';

class ChartDataModel {
  String? category;
  int? amount;
  int? percentage;

  ChartDataModel({this.category, this.amount, this.percentage});

  ChartDataModel.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    amount = json['amount'];
    percentage = json['percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    data['amount'] = amount;
    data['percentage'] = percentage;
    return data;
  }

  ChartData toEntity() {
    return ChartData(
      category: category,
      amount: amount,
      percentage: percentage,
    );
  }
}
