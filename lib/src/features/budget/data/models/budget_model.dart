import 'budget_data_model.dart';
import 'budget_meta_model.dart';

class BudgetModel {
  bool? success;
  List<BudgetDataModel>? data;
  BudgetMetaModel? meta;

  BudgetModel({this.success, this.data, this.meta});

  BudgetModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <BudgetDataModel>[];
      json['data'].forEach((v) {
        data!.add(BudgetDataModel.fromJson(v));
      });
    }
    meta = json['meta'] != null ? BudgetMetaModel.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    return data;
  }
}
