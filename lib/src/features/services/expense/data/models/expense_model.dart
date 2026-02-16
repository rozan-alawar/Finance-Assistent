import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_category.dart';

class ExpenseModel extends ExpenseEntity {
  final String? description;
  final String? currencyId;

  const ExpenseModel({
    required super.id,
    required super.name,
    required super.amount,
    required super.date,
    required super.category,
    this.description,
    this.currencyId,
  });

  /// Create ExpenseModel from API JSON response
  /// Handles various key formats from the API
  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    // Handle wrapped response: { "data": { ... } }
    final data = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return ExpenseModel(
      id: (data['id'] ?? data['_id'] ?? '').toString(),
      name: data['name'] as String? ?? '',
      amount: _parseDouble(data['amount']),
      date: _parseDate(data['dueDate'] ?? data['date'] ?? data['createdAt']),
      category: ExpenseCategory.fromId(
        data['category'] as String? ?? 'others',
      ),
      description: data['description'] as String?,
      currencyId: data['currencyId'] as String?,
    );
  }

  /// Convert to JSON for POST /api/v1/expenses (create expense)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'category': category.id.toUpperCase(),
      'dueDate': date.toIso8601String().split('T')[0], // "2026-02-01"
      if (description != null && description!.isNotEmpty)
        'description': description,
      if (currencyId != null && currencyId!.isNotEmpty)
        'currencyId': currencyId,
    };
  }

  /// Create ExpenseModel from ExpenseEntity
  factory ExpenseModel.fromEntity(ExpenseEntity entity) {
    return ExpenseModel(
      id: entity.id,
      name: entity.name,
      amount: entity.amount,
      date: entity.date,
      category: entity.category,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }
}
