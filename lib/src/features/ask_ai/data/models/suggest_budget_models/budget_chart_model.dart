import 'budget_chart_data_model.dart';

class BudgetChartModel {
  bool? success;
  BudgetChartDataModel? data;

  BudgetChartModel({this.success, this.data});

  BudgetChartModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null
        ? BudgetChartDataModel.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
