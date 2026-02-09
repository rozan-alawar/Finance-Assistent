import 'income_transaction_model.dart';
import 'income_breakdown_model.dart';

class IncomeOverviewModel {
  final List<IncomeBreakdown> breakdownData;
  final List<IncomeTransaction> recentTransactions;

  const IncomeOverviewModel({
    required this.breakdownData,
    required this.recentTransactions,
  });
}