import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_category.dart';

class ExpenseModel extends ExpenseEntity {
  const ExpenseModel({
    required super.id,
    required super.name,
    required super.amount,
    required super.date,
    required super.category,
  });

  /// Create ExpenseModel from JSON map
  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      category: ExpenseCategory.fromId(json['category'] as String),
    );
  }

  /// Convert ExpenseModel to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category.id,
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
}
