import '../../domain/entities/expense_category.dart';

/// Model for category breakdown API response
/// GET /api/v1/expenses/categories/breakdown
/// Response: { "success": true, "data": [{ "category": "FOOD", "totalAmount": "250.25", "percentage": 35.5 }] }
class CategoryBreakdownModel {
  final String categoryId;
  final String categoryName;
  final double amount;
  final double percentage;

  const CategoryBreakdownModel({
    required this.categoryId,
    required this.categoryName,
    required this.amount,
    required this.percentage,
  });

  factory CategoryBreakdownModel.fromJson(Map<String, dynamic> json) {
    final categoryStr = json['category'] as String? ??
        json['categoryId'] as String? ??
        '';
    final category = ExpenseCategory.fromId(categoryStr);

    return CategoryBreakdownModel(
      categoryId: categoryStr,
      categoryName: json['categoryName'] as String? ?? category.name,
      amount: _parseDouble(json['totalAmount'] ?? json['amount']),
      percentage: _parseDouble(json['percentage']),
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
    };
  }

  /// Convert to ExpenseCategory enum
  ExpenseCategory get category => ExpenseCategory.fromId(categoryId);
}

/// Response wrapper for categories breakdown list
class CategoriesBreakdownResponse {
  final List<CategoryBreakdownModel> categories;
  final double totalExpenses;

  const CategoriesBreakdownResponse({
    required this.categories,
    required this.totalExpenses,
  });

  /// Parse from the full API response: { "success": true, "data": [...] }
  factory CategoriesBreakdownResponse.fromJson(Map<String, dynamic> json) {
    // Handle wrapped response: { "data": [...] }
    final rawData = json['data'] ?? json['categories'] ?? [];
    final List<dynamic> categoriesList =
        rawData is List ? rawData : [];

    final categories = categoriesList
        .map((e) => CategoryBreakdownModel.fromJson(e as Map<String, dynamic>))
        .toList();

    // Calculate total from items if not provided
    double total = 0;
    for (final cat in categories) {
      total += cat.amount;
    }

    return CategoriesBreakdownResponse(
      categories: categories,
      totalExpenses: (json['totalExpenses'] as num?)?.toDouble() ?? total,
    );
  }

  /// Convert to Map<ExpenseCategory, double> for use in state
  Map<ExpenseCategory, double> toExpensesByCategoryMap() {
    final Map<ExpenseCategory, double> result = {};
    for (final category in categories) {
      result[category.category] = category.amount;
    }
    return result;
  }
}
