import 'chart_data_model.dart';

class BudgetChartDataModel {
  List<ChartDataModel>? data;

  BudgetChartDataModel({this.data});

  BudgetChartDataModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ChartDataModel>[];
      final dynamic dataContent = json['data'];

      if (dataContent is Map<String, dynamic> &&
          dataContent.containsKey('data')) {
        final innerData = dataContent['data'];
        if (innerData is List) {
          for (var v in innerData) {
            data!.add(ChartDataModel.fromJson(v));
          }
        }
      } else if (dataContent is List) {
        for (var v in dataContent) {
          data!.add(ChartDataModel.fromJson(v));
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
