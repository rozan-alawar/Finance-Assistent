import 'package:finance_assistent/src/core/gen/app_assets.dart';
import 'package:finance_assistent/src/features/budget/data/models/grid_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/bill_data.dart';
import '../../domain/entity/budget_data.dart';
import '../../domain/entity/budget_summary.dart';
import '../../domain/entity/category_chart_date.dart';
import '../../domain/entity/debts_summary.dart';
import '../../domain/entity/income_summary.dart';
import '../../domain/usecase/get_budget_summary_usecase.dart';
import '../../domain/usecase/get_budget_usecase.dart';
import '../../domain/usecase/get_total_debts_usecase.dart';
import '../../domain/usecase/get_total_income_usecase.dart';
import '../../domain/usecase/get_bills_usecase.dart';
import 'budget_state.dart';

class BudgetCubit extends Cubit<BudgetState> {
  final GetBudgetUsecase getBudgetUsecase;
  final GetBillsUseCase getBillsUseCase;
  final GetBudgetSummaryUsecase getBudgetSummaryUsecase;
  final GetTotalDebtsUsecase getTotalDebtsUsecase;
  final GetTotalIncomeUseCase getTotalIncomeUseCase;

  BudgetCubit(
    this.getBudgetUsecase,
    this.getBillsUseCase,
    this.getBudgetSummaryUsecase,
    this.getTotalDebtsUsecase,
    this.getTotalIncomeUseCase,
  ) : super(InitialBudgetState());

  List<BudgetData> allBudgets = [];
  List<BillData> allBills = [];

  BudgetSummary? _summary;
  DebtsSummary? _debtsSummary;
  IncomeSummary? _incomeSummary;

  Future<void> getBudgets() async {
    emit(BudgetLoadingState());
    try {
      final result = await getBudgetUsecase();
      allBudgets = result;
      emit(BudgetLoadedState(result));
    } catch (e) {
      emit(BudgetErrorState(e.toString()));
    }
  }

  Future<void> getBills() async {
    emit(BillsLoadingState());
    try {
      final result = await getBillsUseCase();
      allBills = result;
      emit(BillsLoadedState(result));
    } catch (e) {
      emit(BillsErrorState(e.toString()));
    }
  }

  Future<void> getSummary() async {
    emit(BudgetSummaryLoadingState());
    try {
      final result = await getBudgetSummaryUsecase();
      _summary = result;
      _cachedGridItems = null;
      emit(BudgetSummaryLoadedState(result));
    } catch (e) {
      emit(BudgetSummaryErrorState(e.toString()));
    }
  }

  Future<void> getDebts() async {
    emit(DebtsSummaryLoadingState());
    try {
      final result = await getTotalDebtsUsecase();
      _debtsSummary = result;
      _cachedGridItems = null; // invalidate cache so grid rebuilds
      emit(DebtsSummaryLoadedState(result));
    } catch (e) {
      emit(DebtsSummaryErrorState(e.toString()));
    }
  }

  Future<void> getIncome() async {
    emit(IncomeSummaryLoadingState());
    try {
      final result = await getTotalIncomeUseCase();
      _incomeSummary = result;
      _cachedGridItems = null;
      emit(IncomeSummaryLoadedState(result));
    } catch (e) {
      emit(IncomeSummaryErrorState(e.toString()));
    }
  }

  List<CategoryChartData> get chartData {
    if (allBudgets.isEmpty) return [];

    double total = 0;
    Map<String, double> categorySums = {};

    for (var budget in allBudgets) {
      double amount = double.tryParse(budget.allocatedAmount ?? '0') ?? 0;
      total += amount;
      String category = budget.category ?? 'Unknown';
      categorySums[category] = (categorySums[category] ?? 0) + amount;
    }

    var sortedCategories = categorySums.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    const List<Color> colors = [
      Color(0xFF686FFF),
      Color(0xFFFFA9DC),
      Color(0xFFFFBDBC),
      Color(0xFF5792FF),
    ];
    const List<Color> bgColors = [
      Color.fromARGB(255, 242, 242, 255),
      Color.fromARGB(255, 255, 245, 250),
      Color.fromARGB(255, 255, 247, 247),
      Color.fromARGB(255, 242, 247, 255),
    ];

    List<CategoryChartData> result = [];
    for (int i = 0; i < sortedCategories.length; i++) {
      double amount = sortedCategories[i].value;
      int pct = total == 0 ? 0 : ((amount / total) * 100).round();

      result.add(
        CategoryChartData(
          title: sortedCategories[i].key,
          amount: amount,
          percentage: pct,
          color: colors[i % colors.length],
          textColor: colors[i % colors.length],
          bgColor: bgColors[i % bgColors.length],
        ),
      );
    }
    return result;
  }

  final String sendModeyIcon = AppAssets.ASSETS_ICONS_MONEY_SEND_SVG;
  final String receiveMoneyIcon = AppAssets.ASSETS_ICONS_MONEY_RECIVE_SVG;
  final String increaseArrowIcon = AppAssets.ASSETS_ICONS_INCREASE_ARROW_SVG;
  final String decreaseArrowIcon = AppAssets.ASSETS_ICONS_DECREASE_ARROW_SVG;

  double _balanceChangePercent() {
    final utilisation = _summary?.utilizationPercentage ?? 0;
    return (utilisation - 50).abs().toDouble();
  }

  double _expensesChangePercent() {
    final utilisation = _summary?.utilizationPercentage ?? 0;
    return utilisation.toDouble();
  }

  double _debtsChangePercent() {
    final totalOwe = double.tryParse(_debtsSummary?.totalOwe ?? '0') ?? 0;
    if (totalOwe == 0) return 0;
    const double simulatedLastMonth = 0.8;
    final change = ((1 - simulatedLastMonth) / simulatedLastMonth) * 100;
    return change.abs();
  }

  double _incomeChangePercent() {
    final totalIncome =
        double.tryParse(_incomeSummary?.totalIncome ?? '0') ?? 0;
    if (totalIncome == 0) return 0;
    // Simulate previous month as 85 % of current → ~17.6 % increase.
    // Replace with real previous-month data when the API supports it.
    const double simulatedLastMonth = 0.85;
    final change = ((1 - simulatedLastMonth) / simulatedLastMonth) * 100;
    return change.abs();
  }

  List<GridItemModel>? _cachedGridItems;

  List<GridItemModel> get gridItems {
    _cachedGridItems ??= _buildGridItems();
    return _cachedGridItems!;
  }

  List<GridItemModel> _buildGridItems() {
    final totalRemaining = (_summary?.totalRemaining ?? 0).toDouble();
    final totalSpent = (_summary?.totalSpent ?? 0).toDouble();

    final int utilisation = _summary?.utilizationPercentage ?? 0;

    final bool balanceIsUp = utilisation <= 50;

    final String balanceArrow = balanceIsUp
        ? increaseArrowIcon
        : decreaseArrowIcon;

    final bool expensesIsUp = utilisation > 50;

    final String expensesArrow = expensesIsUp
        ? increaseArrowIcon
        : decreaseArrowIcon;

    return [
      // --- Card 0: Balance  (totalRemaining from /budgets/summary) ---
      GridItemModel(
        title: 'Balance',
        amount: totalRemaining,
        percentage: _balanceChangePercent(),
        icon: receiveMoneyIcon,
        iconColor: const Color(0xFFFF7292),
        backgoundColor: const Color(0xFFFDF5F7),
        arrow: balanceArrow,
      ),
      // --- Card 1: Revenues  (totalIncome from /incomes/summary) ---
      GridItemModel(
        title: 'Revenues',
        amount: double.tryParse(_incomeSummary?.totalIncome ?? '0') ?? 0,
        percentage: _incomeChangePercent(),
        icon: receiveMoneyIcon,
        iconColor: const Color(0xFF6133BD),
        backgoundColor: const Color(0xFFEBE5F7),
        arrow: (double.tryParse(_incomeSummary?.totalIncome ?? '0') ?? 0) > 0
            ? increaseArrowIcon
            : decreaseArrowIcon,
      ),
      // --- Card 2: Expenses  (totalSpent from /budgets/summary) ---
      GridItemModel(
        title: 'Expenses',
        amount: totalSpent,
        percentage: _expensesChangePercent(),
        icon: sendModeyIcon,
        iconColor: const Color(0xFF16C087),
        backgoundColor: const Color(0xFFDCFCE7),
        arrow: expensesArrow,
      ),
      // --- Card 3: Total Debt  (totalOwe from /debts/summary) ---
      GridItemModel(
        title: 'Total Debt',
        amount: double.tryParse(_debtsSummary?.totalOwe ?? '0') ?? 0,
        percentage: _debtsChangePercent(),
        icon: AppAssets.ASSETS_ICONS_DEBTS_SVG,
        iconColor: const Color(0xFF686FFF),
        backgoundColor: const Color(0xFFEFF1FF),
        arrow: (double.tryParse(_debtsSummary?.totalOwe ?? '0') ?? 0) > 0
            ? increaseArrowIcon
            : decreaseArrowIcon,
      ),
    ];
  }
}
