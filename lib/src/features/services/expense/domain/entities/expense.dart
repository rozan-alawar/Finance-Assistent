import 'expense_category.dart';

class ExpenseEntity {
  final String id;
  final String name;
  final double amount;
  final DateTime date;
  final ExpenseCategory category;

  const ExpenseEntity({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.category,
  });

  ExpenseEntity copyWith({
    String? id,
    String? name,
    double? amount,
    DateTime? date,
    ExpenseCategory? category,
  }) {
    return ExpenseEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExpenseEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
