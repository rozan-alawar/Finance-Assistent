import 'package:finance_assistent/src/core/gen/app_assets.dart';
import 'package:finance_assistent/src/features/budget/data/models/grid_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/budget_data.dart';
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
