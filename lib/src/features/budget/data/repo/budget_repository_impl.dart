import 'package:finance_assistent/src/features/budget/domain/entity/ai_chat.dart';
import 'package:finance_assistent/src/features/budget/domain/entity/bill_data.dart';
import 'package:finance_assistent/src/features/budget/domain/entity/budget_summary.dart';
import 'package:finance_assistent/src/features/budget/domain/entity/debts_summary.dart';
import 'package:finance_assistent/src/features/budget/domain/entity/income_summary.dart';

import '../../domain/entity/budget_data.dart';
import '../../domain/repo/budget_repository.dart';
import '../datasource/budget_remote_datasource.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetRemoteDatasource remoteDatasource;

  BudgetRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<BudgetData>> getBudgets() async {
    final models = await remoteDatasource.getBudgets();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<BudgetSummary> getSummary() async {
    final models = await remoteDatasource.getSummary();
    return models.toEntity();
  }

  @override
  Future<AiChat> askAI(String message, {String? chatId}) async {
    final model = await remoteDatasource.askAI(message, chatId: chatId);
    return model.data!.toEntity();
  }

  @override
  Future<DebtsSummary> getTotalDebts() async {
    final model = await remoteDatasource.getTotalDebts();
    return model.toDebtsSummary();
  }

  @override
  Future<IncomeSummary> getTotalIncome() async {
    final model = await remoteDatasource.getTotalIncome();
    return model.toIncomeSummary();
  }

  @override
  Future<List<BillData>> getBills() async {
    final models = await remoteDatasource.getBills();
    return models.map((e) => e.toEntity()).toList();
  }
}
