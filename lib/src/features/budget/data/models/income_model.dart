import '../../domain/entity/income_summary.dart';

class IncomeModel {
  bool? success;
  IncomeDataModel? data;

  IncomeModel({this.success, this.data});

  IncomeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? IncomeDataModel.fromJson(json['data']) : null;
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

class IncomeDataModel {
  String? totalIncome;
  int? count;

  IncomeDataModel({this.totalIncome, this.count});

  IncomeDataModel.fromJson(Map<String, dynamic> json) {
    totalIncome = json['totalIncome'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalIncome'] = totalIncome;
    data['count'] = count;
    return data;
  }

  IncomeSummary toIncomeSummary() {
    return IncomeSummary(totalIncome: totalIncome);
  }
}
