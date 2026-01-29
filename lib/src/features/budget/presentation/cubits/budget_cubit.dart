import 'package:finance_assistent/src/core/gen/app_assets.dart';
import 'package:finance_assistent/src/features/budget/data/model/grid_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'budget_state.dart';

class BudgetCubit extends Cubit<BudgetState> {
  BudgetCubit() : super(InitialBudgetState());

  final String sendModeyIcon = AppAssets.ASSETS_ICONS_MONEY_SEND_SVG;
  final String receiveMoneyIcon = AppAssets.ASSETS_ICONS_MONEY_RECIVE_SVG;
  final String increaseArrowIcon = AppAssets.ASSETS_ICONS_INCREASE_ARROW_SVG;
  final String decreaseArrowIcon = AppAssets.ASSETS_ICONS_DECREASE_ARROW_SVG;

  List<GridItemModel> get gridItems => [
    GridItemModel(
      title: 'Balance',
      amount: 10967.0,
      percentage: 8.2,
      icon: receiveMoneyIcon,
      iconColor: Color(0xFFFF7292),
      backgoundColor: const Color(0xFFFDF5F7),
      arrow: increaseArrowIcon,
    ),
    GridItemModel(
      title: 'Revenues',
      amount: 1700.0,
      percentage: -2.5,
      icon: receiveMoneyIcon,
      iconColor: Color(0xFF6133BD),

      backgoundColor: const Color(0xFFEBE5F7),
      arrow: decreaseArrowIcon,
    ),
    GridItemModel(
      title: 'Expenses',
      amount: 2558.0,
      percentage: 2.0,
      icon: sendModeyIcon,
      iconColor: Color(0xFF16C087),
      backgoundColor: const Color(0xFFDCFCE7),
      arrow: increaseArrowIcon,
    ),
    GridItemModel(
      title: 'Total Debt',
      amount: 12450,
      percentage: 2.5,
      icon: AppAssets.ASSETS_ICONS_DEBTS_SVG,
      iconColor: Color(0xFF686FFF),
      backgoundColor: const Color(0xFFEFF1FF),
      arrow: increaseArrowIcon,
    ),
  ];
}
