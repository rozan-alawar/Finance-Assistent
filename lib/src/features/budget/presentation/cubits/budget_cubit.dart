import 'package:finance_assistent/src/core/gen/app_assets.dart';
import 'package:finance_assistent/src/features/budget/data/models/grid_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/budget_data.dart';
import '../../domain/entity/category_chart_date.dart';
import '../../domain/usecase/get_budget_usecase.dart';
import 'budget_state.dart';

class BudgetCubit extends Cubit<BudgetState> {
  final GetBudgetUsecase getBudgetUsecase;

  BudgetCubit(this.getBudgetUsecase) : super(InitialBudgetState());

  List<BudgetData> allBudgets = [];

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
      if (i >= 4) break;
      double amount = sortedCategories[i].value;
      int pct = total == 0 ? 0 : ((amount / total) * 100).round();

      result.add(
        CategoryChartData(
          title: sortedCategories[i].key,
          amount: amount,
          percentage: pct,
          // Cycle through our pre-defined colors for UI consistency
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

  // Cache gridItems to avoid recreation on every access
  List<GridItemModel>? _cachedGridItems;

  List<GridItemModel> get gridItems {
    _cachedGridItems ??= [
      GridItemModel(
        title: 'Balance',
        amount: 10967.0,
        percentage: 8.2,
        icon: receiveMoneyIcon,
        iconColor: const Color(0xFFFF7292),
        backgoundColor: const Color(0xFFFDF5F7),
        arrow: increaseArrowIcon,
      ),
      GridItemModel(
        title: 'Revenues',
        amount: 1700.0,
        percentage: -2.5,
        icon: receiveMoneyIcon,
        iconColor: const Color(0xFF6133BD),
        backgoundColor: const Color(0xFFEBE5F7),
        arrow: decreaseArrowIcon,
      ),
      GridItemModel(
        title: 'Expenses',
        amount: 2558.0,
        percentage: 2.0,
        icon: sendModeyIcon,
        iconColor: const Color(0xFF16C087),
        backgoundColor: const Color(0xFFDCFCE7),
        arrow: increaseArrowIcon,
      ),
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
    return _cachedGridItems!;
  }
}
