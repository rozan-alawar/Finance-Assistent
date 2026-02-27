import '../../domain/entity/budget_summary.dart';

class SummaryDataModel {
  int? totalAllocated;
  int? totalSpent;
  int? totalRemaining;
  int? utilizationPercentage;

  SummaryDataModel({
    this.totalAllocated,
    this.totalSpent,
    this.totalRemaining,
    this.utilizationPercentage,
  });

  SummaryDataModel.fromJson(Map<String, dynamic> json) {
    totalAllocated = json['totalAllocated'];
    totalSpent = json['totalSpent'];
    totalRemaining = json['totalRemaining'];
    utilizationPercentage = json['utilizationPercentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalAllocated'] = totalAllocated;
    data['totalSpent'] = totalSpent;
    data['totalRemaining'] = totalRemaining;
    data['utilizationPercentage'] = utilizationPercentage;
    return data;
  }

  BudgetSummary toEntity() {
    return BudgetSummary(
      totalAllocated: totalAllocated,
      totalSpent: totalSpent,
      totalRemaining: totalRemaining,
      utilizationPercentage: utilizationPercentage,
    );
  }
}
