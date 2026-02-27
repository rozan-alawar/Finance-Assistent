import 'package:finance_assistent/src/features/income/data/model/add_income_model.dart';
import 'package:finance_assistent/src/features/income/data/model/income_breakdown_model.dart';
import 'package:finance_assistent/src/features/income/data/model/income_chart_data.dart';
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
      final summary = await _repository.getSummary();
      final incomes = await _repository.getIncomes(limit: 50);

      // Group incomes by source for breakdown
      final Map<String, double> sourceMap = {};
      double breakdownTotalAmount = 0;

      for (var income in incomes) {
        sourceMap[income.source] =
            (sourceMap[income.source] ?? 0) + income.amount;
        breakdownTotalAmount += income.amount;
      }

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
          percentage: breakdownTotalAmount == 0
              ? 0
              : (e.value / breakdownTotalAmount) * 100,
          color: color,
        );
      }).toList();

      final recentTransactions = incomes.take(10).map((e) {
        return IncomeTransaction(
          title: e.source, // Using source as title
          amount: e.amount,
          date: DateFormat('dd MMM').format(e.incomeDate),
          isMonthly: false, // Defaulting to false as API doesn't specify
        );
      }).toList();

      // Chart Data Calculation (Last 7 Days)
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 6)); // 7 days including today
      final Map<String, double> dailyIncome = {};

      // Initialize map for last 7 days
      for (int i = 0; i < 7; i++) {
        final date = sevenDaysAgo.add(Duration(days: i));
        final dayLabel = DateFormat('E').format(date); // Mon, Tue, etc.
        dailyIncome[dayLabel] = 0;
      }

      for (var income in incomes) {
        if (income.incomeDate.isAfter(sevenDaysAgo.subtract(const Duration(days: 1))) &&
            income.incomeDate.isBefore(now.add(const Duration(days: 1)))) {
           final dayLabel = DateFormat('E').format(income.incomeDate);
           if (dailyIncome.containsKey(dayLabel)) {
             dailyIncome[dayLabel] = (dailyIncome[dayLabel] ?? 0) + income.amount;
           }
        }
      }

      final chartData = dailyIncome.entries.map((e) {
        return IncomeChartData(label: e.key, amount: e.value);
      }).toList();


      final data = IncomeOverviewModel(
        totalIncome: summary.totalIncome,
        chartData: chartData,
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
