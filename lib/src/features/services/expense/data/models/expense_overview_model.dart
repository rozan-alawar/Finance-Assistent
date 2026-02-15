/// Model for expense overview API response
/// GET /api/v1/expenses/overview
/// Response: { "success": true, "message": "...", "data": { "totalBalance": "1200.50", "totalIncome": "3500.00", "totalExpenses": "2299.50" } }
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

  /// Parse from the `data` object inside the API response
  factory ExpenseOverviewModel.fromJson(Map<String, dynamic> json) {
    // Handle wrapped response: { "data": { ... } }
    final data = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return ExpenseOverviewModel(
      totalBalance: _parseDouble(data['totalBalance']),
      income: _parseDouble(data['totalIncome'] ?? data['income']),
      expenses: _parseDouble(data['totalExpenses'] ?? data['expenses']),
      percentageChange: _parseDouble(data['percentageChange']),
    );
  }

  /// Parse a value that could be a String, num, or null into a double
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'totalBalance': totalBalance,
      'totalIncome': income,
      'totalExpenses': expenses,
      'percentageChange': percentageChange,
    };
  }
}
