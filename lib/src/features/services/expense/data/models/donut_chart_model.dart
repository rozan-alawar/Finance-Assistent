import '../../domain/entities/expense_category.dart';

/// Model for donut chart data item
/// GET /api/v1/expenses/charts/donut
class DonutChartItemModel {
  final String categoryId;
  final String categoryName;
  final double amount;
  final double percentage;
  final String color;

  const DonutChartItemModel({
    required this.categoryId,
    required this.categoryName,
    required this.amount,
    required this.percentage,
    required this.color,
  });

  factory DonutChartItemModel.fromJson(Map<String, dynamic> json) {
    return DonutChartItemModel(
      categoryId: json['categoryId'] as String? ?? json['category'] as String? ?? '',
      categoryName: json['categoryName'] as String? ?? json['name'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      color: json['color'] as String? ?? '#78909C',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'amount': amount,
      'percentage': percentage,
      'color': color,
    };
  }

  /// Get ExpenseCategory enum
  ExpenseCategory get category => ExpenseCategory.fromId(categoryId);
}

/// Response wrapper for donut chart
class DonutChartResponse {
  final List<DonutChartItemModel> items;
  final double totalAmount;

  const DonutChartResponse({
    required this.items,
    required this.totalAmount,
  });

  factory DonutChartResponse.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>? ?? 
                       json['data'] as List<dynamic>? ?? [];
    return DonutChartResponse(
      items: itemsList
          .map((e) => DonutChartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 
                   (json['total'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Convert to Map<ExpenseCategory, double> for chart widget
  Map<ExpenseCategory, double> toExpensesByCategoryMap() {
    final Map<ExpenseCategory, double> result = {};
    for (final item in items) {
      result[item.category] = item.amount;
    }
    return result;
  }
}

