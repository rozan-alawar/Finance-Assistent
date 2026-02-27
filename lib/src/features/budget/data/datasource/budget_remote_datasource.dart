import '../../../../core/network/api_endpoints.dart';
import '../../../../core/services/network/main_service/network_service.dart';
import '../models/ai_chat_model.dart';
import '../models/budget_data_model.dart';
import '../models/budget_model.dart';
import '../models/budget_summary_model.dart';
import '../models/debts_model.dart';
import '../models/income_model.dart';
import '../models/summary_data_model.dart';

abstract class BudgetRemoteDatasource {
  Future<List<BudgetDataModel>> getBudgets();
  Future<SummaryDataModel> getSummary();
  Future<AiChatModel> askAI(String message, {String? chatId});
  Future<DebtsDataModel> getTotalDebts();
  Future<IncomeDataModel> getTotalIncome();
}

class BudgetRemoteDataSourceImpl implements BudgetRemoteDatasource {
  const BudgetRemoteDataSourceImpl(this.networkService);

  final NetworkService networkService;

  @override
  Future<List<BudgetDataModel>> getBudgets() async {
    final response = await networkService.get<Map<String, dynamic>>(
      path: ApiEndpoints.budgets,
    );

    if (response.statusCode == 200) {
      final budgetModel = BudgetModel.fromJson(response.data!);
      return budgetModel.data ?? [];
    } else {
      throw Exception('Failed to load budgets');
    }
  }

  @override
  Future<SummaryDataModel> getSummary() async {
    final response = await networkService.get<Map<String, dynamic>>(
      path: ApiEndpoints.budgetSummary,
    );

    if (response.statusCode == 200) {
      final budgetSummaryModel = BudgetSummaryModel.fromJson(response.data!);
      return budgetSummaryModel.data!;
    } else {
      throw Exception('Failed to load budgets');
    }
  }

  @override
  Future<AiChatModel> askAI(String message, {String? chatId}) async {
    final response = await networkService.post<Map<String, dynamic>>(
      path: ApiEndpoints.aiChat,
      data: {'message': message, if (chatId != null) 'chatId': chatId},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final aiChatModel = AiChatModel.fromJson(response.data!);
      return aiChatModel;
    } else {
      throw Exception('Failed to send message');
    }
  }

  @override
  Future<DebtsDataModel> getTotalDebts() async {
    final response = await networkService.get<Map<String, dynamic>>(
      path: ApiEndpoints.debtsSummary,
    );

    if (response.statusCode == 200) {
      final debtsModel = DebtsModel.fromJson(response.data!);
      return debtsModel.data!;
    } else {
      throw Exception('Failed to get total debts');
    }
  }

  @override
  Future<IncomeDataModel> getTotalIncome() async {
    final response = await networkService.get<Map<String, dynamic>>(
      path: ApiEndpoints.incomeSummary,
    );

    if (response.statusCode == 200) {
      final incomeModel = IncomeModel.fromJson(response.data!);
      return incomeModel.data!;
    } else {
      throw Exception('Failed to get total income');
    }
  }
}
