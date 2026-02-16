import '../../domain/entities/expense_category.dart';

/// Model for donut chart data item
/// GET /api/v1/expenses/charts/donut
/// Response: { "success": true, "data": [{ "category": "FOOD", "totalAmount": "250.25", "percentage": 35.5 }] }
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
    final categoryStr = json['category'] as String? ??
        json['categoryId'] as String? ??
        '';
    final category = ExpenseCategory.fromId(categoryStr);

    return DonutChartItemModel(
      categoryId: categoryStr,
      categoryName: json['categoryName'] as String? ?? category.name,
      amount: _parseDouble(json['totalAmount'] ?? json['amount']),
      percentage: _parseDouble(json['percentage']),
      color: json['color'] as String? ??
          '#${category.color.value.toRadixString(16).substring(2)}',
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'category': categoryId,
      'totalAmount': amount,
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

  /// Parse from the full API response: { "success": true, "data": [...] }
  factory DonutChartResponse.fromJson(Map<String, dynamic> json) {
    // Handle wrapped response: { "data": [...] }
    final rawData = json['data'] ?? json['items'] ?? [];
    final List<dynamic> itemsList = rawData is List ? rawData : [];

    final items = itemsList
        .map((e) => DonutChartItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    // Calculate total from items if not provided
    double total = 0;
    for (final item in items) {
      total += item.amount;
    }

    return DonutChartResponse(
      items: items,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ??
          (json['total'] as num?)?.toDouble() ??
          total,
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
