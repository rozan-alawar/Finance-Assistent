import '../../domain/entity/debts_summary.dart';

class DebtsModel {
  bool? success;
  DebtsDataModel? data;

  DebtsModel({this.success, this.data});

  DebtsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? DebtsDataModel.fromJson(json['data']) : null;
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

class DebtsDataModel {
  String? totalOwed;
  String? totalOwe;
  String? netBalance;
  int? unpaidCount;

  DebtsDataModel({
    this.totalOwed,
    this.totalOwe,
    this.netBalance,
    this.unpaidCount,
  });

  DebtsDataModel.fromJson(Map<String, dynamic> json) {
    totalOwed = json['totalOwed'];
    totalOwe = json['totalOwe'];
    netBalance = json['netBalance'];
    unpaidCount = json['unpaidCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalOwed'] = totalOwed;
    data['totalOwe'] = totalOwe;
    data['netBalance'] = netBalance;
    data['unpaidCount'] = unpaidCount;
    return data;
  }

  DebtsSummary toDebtsSummary() {
    return DebtsSummary(totalOwed: totalOwed, totalOwe: totalOwe);
  }
}
