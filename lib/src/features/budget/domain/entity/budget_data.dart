class BudgetData {
  final String? id;
  final String? userId;
  final String? category;
  final String? allocatedAmount;
  final String? spentAmount;
  final String? startDate;
  final String? endDate;
  final String? description;
  final String? createdAt;
  final String? updatedAt;
  // status: (Paid - Unpaid - OverDue)
  final String? status;

  const BudgetData({
    this.id,
    this.userId,
    this.category,
    this.allocatedAmount,
    this.spentAmount,
    this.startDate,
    this.endDate,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.status = 'paid',
  });
}
