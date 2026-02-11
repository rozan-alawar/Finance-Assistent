/// Model for expense overview API response
/// GET /api/v1/expenses/overview
class ExpenseOverviewModel {
  final double totalBalance;
  final double income;
  final double expenses;
  final double percentageChange;

  const ExpenseOverviewModel({
    required this.totalBalance,
    required this.income,
    required this.expenses,
    required this.percentageChange,
  });

  factory ExpenseOverviewModel.fromJson(Map<String, dynamic> json) {
    return ExpenseOverviewModel(
      totalBalance: (json['totalBalance'] as num?)?.toDouble() ?? 0.0,
      income: (json['income'] as num?)?.toDouble() ?? 0.0,
      expenses: (json['expenses'] as num?)?.toDouble() ?? 0.0,
      percentageChange: (json['percentageChange'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalBalance': totalBalance,
      'income': income,
      'expenses': expenses,
      'percentageChange': percentageChange,
    };
  }
}

