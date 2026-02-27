import 'package:flutter/material.dart';

// ==========================================
// 1. Report Data Model
// ==========================================
class ReportDataModel {
  final String netBalance;
  final String totalExpense;
  final String totalBalance;
  final String paidAmount;
  final String dateRange;
  final List<CategoryModel> categories;
  final String donutTotalAmount;
  final BillModel paidBills;
  final BillModel unpaidBills;
  final BillModel overdueBills;
  final BillModel totalBills;

  const ReportDataModel({
    required this.netBalance,
    required this.totalExpense,
    required this.totalBalance,
    required this.paidAmount,
    required this.dateRange,
    required this.categories,
    required this.donutTotalAmount,
    required this.paidBills,
    required this.unpaidBills,
    required this.overdueBills,
    required this.totalBills,
  });

  factory ReportDataModel.fromMap(Map<String, dynamic> map) {
    return ReportDataModel(
      netBalance: map['net_balance']?.toString() ?? "\$0.00",
      totalExpense: map['total_expense']?.toString() ?? "\$0.00",
      totalBalance: map['total_balance']?.toString() ?? "\$0.00",
      paidAmount: map['paid_amount']?.toString() ?? "\$0.00",
      dateRange: map['date_range']?.toString() ?? "",
      donutTotalAmount: map['donut_total_amount']?.toString() ?? "\$0.00",
      categories: map['categories'] != null 
          ? List<CategoryModel>.from(map['categories'].map((x) => CategoryModel.fromMap(x))) 
          : [],
      paidBills: BillModel.fromMap(map['paid_bills'] ?? {}),
      unpaidBills: BillModel.fromMap(map['unpaid_bills'] ?? {}),
      overdueBills: BillModel.fromMap(map['overdue_bills'] ?? {}),
      totalBills: BillModel.fromMap(map['total_bills'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'net_balance': netBalance,
      'total_expense': totalExpense,
      'total_balance': totalBalance,
      'paid_amount': paidAmount,
      'date_range': dateRange,
      'donut_total_amount': donutTotalAmount,
      'categories': categories.map((x) => x.toMap()).toList(),
      'paid_bills': paidBills.toMap(),
      'unpaid_bills': unpaidBills.toMap(),
      'overdue_bills': overdueBills.toMap(),
      'total_bills': totalBills.toMap(),
    };
  }
}

class ReportDataMapper {
  static ReportDataModel fromMap(Map<String, dynamic> map) {
    return ReportDataModel.fromMap(map);
  }
}

// ==========================================
// 2. Category Model
// ==========================================
class CategoryModel {
  final String title;
  final String amount;
  final Color color;

  const CategoryModel({required this.title, required this.amount, required this.color});

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      title: map['title']?.toString() ?? "",
      amount: map['amount']?.toString() ?? "\$0.00",
      color: Color(int.parse(map['color']?.toString() ?? "0xFF000000")), 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'color': color.value.toString(),
    };
  }
}

// ==========================================
// 3. Bill Model
// ==========================================
class BillModel {
  final String subtitle;
  final String amount;
  final String percentage;

  const BillModel({required this.subtitle, required this.amount, required this.percentage});

  factory BillModel.fromMap(Map<String, dynamic> map) {
    return BillModel(
      subtitle: map['subtitle']?.toString() ?? "",
      amount: map['amount']?.toString() ?? "\$0.00",
      percentage: map['percentage']?.toString() ?? "0%",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subtitle': subtitle,
      'amount': amount,
      'percentage': percentage,
    };
  }
}