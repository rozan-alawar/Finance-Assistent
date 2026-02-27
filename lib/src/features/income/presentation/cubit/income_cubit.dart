import 'package:finance_assistent/src/features/income/data/model/add_income_model.dart';
import 'package:finance_assistent/src/features/income/data/model/income_breakdown_model.dart';
import 'package:finance_assistent/src/features/income/data/model/income_overview_model.dart';
import 'package:finance_assistent/src/features/income/data/model/income_transaction_model.dart';
import 'package:finance_assistent/src/features/income/data/repo/income_repository.dart';
import 'package:finance_assistent/src/features/income/presentation/cubit/income_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class IncomeCubit extends Cubit<IncomeState> {
  final IncomeRepository _repository;

  IncomeCubit(this._repository) : super(IncomeInitial());

  void fetchIncomeOverview() async {
    emit(IncomeLoading());
    try {
      final _ = await _repository.getSummary();
      final incomes = await _repository.getIncomes(limit: 10);

      // Group incomes by source for breakdown
      final Map<String, double> sourceMap = {};
      double totalAmount = 0;

      for (var income in incomes) {
        sourceMap[income.source] =
            (sourceMap[income.source] ?? 0) + income.amount;
        totalAmount += income.amount;
      }

      // Use summary total if available and greater than calculated (in case pagination limits breakdown)
      // But summary total might be all time, and breakdown might be expected for recent?
      // For now, let's use the fetched incomes for breakdown to be consistent with what's shown.
      // Or maybe the summary endpoint provides total for everything.
      // The breakdown chart usually shows distribution of total income.
      // If I only fetch 10 items, the breakdown will be biased.
      // But I don't have an endpoint for breakdown.
      // I'll use the fetched incomes for now.

      final List<Color> colors = [
        const Color(0xFF3447AA),
        const Color(0xFFFF9BA1),
        const Color(0xFFFBEAEB),
        Colors.green,
        Colors.orange,
        Colors.purple,
        Colors.teal,
      ];

      int colorIndex = 0;
      final breakdownData = sourceMap.entries.map((e) {
        final color = colors[colorIndex % colors.length];
        colorIndex++;
        return IncomeBreakdown(
          category: e.key,
          amount: e.value,
          percentage: totalAmount == 0 ? 0 : (e.value / totalAmount) * 100,
          color: color,
        );
      }).toList();

      final recentTransactions = incomes.map((e) {
        return IncomeTransaction(
          title: e.source, // Using source as title
          amount: e.amount,
          date: DateFormat('dd MMM').format(e.incomeDate),
          isMonthly: false, // Defaulting to false as API doesn't specify
        );
      }).toList();

      final data = IncomeOverviewModel(
        breakdownData: breakdownData,
        recentTransactions: recentTransactions,
      );

      emit(IncomeSuccess(data));
    } catch (e) {
      emit(IncomeError("Error in fetching income overview: ${e.toString()}"));
    }
  }

  void addIncome(AddIncomeParams params) async {
    emit(IncomeLoading());
    try {
      await _repository.createIncome(params);

      emit(AddIncomeSuccess());

      fetchIncomeOverview();
    } catch (e) {
      emit(IncomeError("Error while adding income: ${e.toString()}"));
    }
  }
}
