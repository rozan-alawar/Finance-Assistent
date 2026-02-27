import 'package:finance_assistent/src/core/gen/app_assets.dart';
import 'package:finance_assistent/src/features/budget/data/models/grid_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/budget_data.dart';
import '../../domain/entity/budget_summary.dart';
import '../../domain/entity/category_chart_date.dart';
import '../../domain/usecase/get_budget_summary_usecase.dart';
import '../../domain/usecase/get_budget_usecase.dart';
import 'budget_state.dart';

class BudgetCubit extends Cubit<BudgetState> {
  final GetBudgetUsecase getBudgetUsecase;
  final GetBudgetSummaryUsecase getBudgetSummaryUsecase;

  BudgetCubit(this.getBudgetUsecase, this.getBudgetSummaryUsecase)
    : super(InitialBudgetState());

  List<BudgetData> allBudgets = [];

  BudgetSummary? _summary;

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
    final double balancePct = _balanceChangePercent();
    final String balanceArrow = balanceIsUp
        ? increaseArrowIcon
        : decreaseArrowIcon;

    final bool expensesIsUp = utilisation > 50;
    final double expensesPct = _expensesChangePercent();
    final String expensesArrow = expensesIsUp
        ? increaseArrowIcon
        : decreaseArrowIcon;

    return [
      // --- Card 0: Balance  (totalRemaining from /budgets/summary) ---
      GridItemModel(
        title: 'Balance',
        amount: totalRemaining,
        percentage: balancePct,
        icon: receiveMoneyIcon,
        iconColor: const Color(0xFFFF7292),
        backgoundColor: const Color(0xFFFDF5F7),
        arrow: balanceArrow,
      ),
      // --- Card 1: Revenues  (static / handled elsewhere) ---
      GridItemModel(
        title: 'Revenues',
        amount: 1700.0,
        percentage: 2.5,
        icon: receiveMoneyIcon,
        iconColor: const Color(0xFF6133BD),
        backgoundColor: const Color(0xFFEBE5F7),
        arrow: increaseArrowIcon,
      ),
      // --- Card 2: Expenses  (totalSpent from /budgets/summary) ---
      GridItemModel(
        title: 'Expenses',
        amount: totalSpent,
        percentage: expensesPct,
        icon: sendModeyIcon,
        iconColor: const Color(0xFF16C087),
        backgoundColor: const Color(0xFFDCFCE7),
        arrow: expensesArrow,
      ),
      // --- Card 3: Total Debt  (static / handled elsewhere) ---
      GridItemModel(
        title: 'Total Debt',
        amount: 12450,
        percentage: 2.5,
        icon: AppAssets.ASSETS_ICONS_DEBTS_SVG,
        iconColor: const Color(0xFF686FFF),
        backgoundColor: const Color(0xFFEFF1FF),
        arrow: increaseArrowIcon,
      ),
    ];
  }
}
