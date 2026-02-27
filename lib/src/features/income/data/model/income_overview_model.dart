import 'income_chart_data.dart';
import 'income_transaction_model.dart';
import 'income_breakdown_model.dart';

class IncomeOverviewModel {
  final double totalIncome;
  final List<IncomeChartData> chartData;
  final List<IncomeBreakdown> breakdownData;
  final List<IncomeTransaction> recentTransactions;

  const IncomeOverviewModel({
    required this.totalIncome,
    required this.chartData,
    required this.breakdownData,
    required this.recentTransactions,
  });
}
