import '../../domain/entities/expense_category.dart';

/// Model for category breakdown API response
/// GET /api/v1/expenses/categories/breakdown
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
    return CategoryBreakdownModel(
      categoryId: json['categoryId'] as String? ?? json['category'] as String? ?? '',
      categoryName: json['categoryName'] as String? ?? json['name'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'amount': amount,
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

  factory CategoriesBreakdownResponse.fromJson(Map<String, dynamic> json) {
    final categoriesList = json['categories'] as List<dynamic>? ?? [];
    return CategoriesBreakdownResponse(
      categories: categoriesList
          .map((e) => CategoryBreakdownModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalExpenses: (json['totalExpenses'] as num?)?.toDouble() ?? 0.0,
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

