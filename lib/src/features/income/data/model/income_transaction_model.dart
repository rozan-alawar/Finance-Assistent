class IncomeTransaction {
  final String title;
  final double amount;
  final String date;
  final bool isMonthly;

  const IncomeTransaction({
    required this.title,
    required this.amount,
    required this.date,
    required this.isMonthly,
  });
}