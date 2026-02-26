import 'summary_data_model.dart';

class BudgetSummaryModel {
  bool? success;
  SummaryDataModel? data;

  BudgetSummaryModel({this.success, this.data});

  BudgetSummaryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null
        ? SummaryDataModel.fromJson(json['data'])
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
