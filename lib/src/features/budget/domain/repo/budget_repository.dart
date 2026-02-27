import '../entity/ai_chat.dart';
import '../entity/budget_data.dart';
import '../entity/budget_summary.dart';
import '../entity/debts_summary.dart';
import '../entity/income_summary.dart';

abstract class BudgetRepository {
  Future<List<BudgetData>> getBudgets();
  Future<BudgetSummary> getSummary();
  Future<DebtsSummary> getTotalDebts();
  Future<IncomeSummary> getTotalIncome();
  Future<AiChat> askAI(String message, {String? chatId});
}
