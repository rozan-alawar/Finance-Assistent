class AddIncomeParams {
  final double amount;
  final String source;
  final DateTime date;
  final String recurringType; 

  AddIncomeParams({
    required this.amount,
    required this.source,
    required this.date,
    required this.recurringType,
  });
}