import 'package:flutter/material.dart';

/// Bill payment status enum
enum BillStatus {
  paid(
    id: 'paid',
    name: 'Paid',
    color: Color(0xFF10B981),
    backgroundColor: Color(0xFFD1FAE5),
  ),
  unpaid(
    id: 'unpaid',
    name: 'Unpaid',
    color: Color(0xFFEF4444),
    backgroundColor: Color(0xFFFEE2E2),
  ),
  overdue(
    id: 'overdue',
    name: 'overdue',
    color: Color(0xFFF97316),
    backgroundColor: Color(0xFFFED7AA),
  );

  final String id;
  final String name;
  final Color color;
  final Color backgroundColor;

  const BillStatus({
    required this.id,
    required this.name,
    required this.color,
    required this.backgroundColor,
  });

  /// Get status from id string
  static BillStatus fromId(String id) {
    return BillStatus.values.firstWhere(
      (status) => status.id.toLowerCase() == id.toLowerCase(),
      orElse: () => BillStatus.unpaid,
    );
  }
}

/// Reminder frequency enum
enum ReminderFrequency {
  none('none', 'None'),
  daily('daily', 'Daily'),
  weekly('weekly', 'weekly'),
  monthly('monthly', 'monthly');

  final String id;
  final String name;

  const ReminderFrequency(this.id, this.name);

  static ReminderFrequency fromId(String id) {
    return ReminderFrequency.values.firstWhere(
      (freq) => freq.id.toLowerCase() == id.toLowerCase(),
      orElse: () => ReminderFrequency.none,
    );
  }
}

/// Split method for group bills
enum SplitMethod {
  equal('equal', 'Equal'),
  percentage('percentage', 'Percentage'),
  custom('custom', 'Custom');

  final String id;
  final String name;

  const SplitMethod(this.id, this.name);

  static SplitMethod fromId(String id) {
    return SplitMethod.values.firstWhere(
      (method) => method.id.toLowerCase() == id.toLowerCase(),
      orElse: () => SplitMethod.equal,
    );
  }
}

