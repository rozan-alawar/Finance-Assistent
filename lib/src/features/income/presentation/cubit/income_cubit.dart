import 'package:finance_assistent/src/features/income/data/model/add_income_model.dart';
import 'package:finance_assistent/src/features/income/data/model/income_breakdown_model.dart';
import 'package:finance_assistent/src/features/income/data/model/income_overview_model.dart';
import 'package:finance_assistent/src/features/income/data/model/income_transaction_model.dart';
import 'package:finance_assistent/src/features/income/presentation/cubit/income_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class IncomeCubit extends Cubit<IncomeState> {
  IncomeCubit() : super(IncomeInitial());

  void fetchIncomeOverview() async {
    emit(IncomeLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));

      final data = IncomeOverviewModel(
        breakdownData: [
          const IncomeBreakdown(
            category: "Salary",
            amount: 7250,
            percentage: 65,
            color: Color(0xFF3447AA),
          ),
          const IncomeBreakdown(
            category: "Freelance",
            amount: 1050,
            percentage: 20,
            color: Color(0xFFFF9BA1),
          ),
          const IncomeBreakdown(
            category: "Business",
            amount: 1000,
            percentage: 15,
            color: Color(0xFFFBEAEB),
          ),
        ],
        recentTransactions: [
          const IncomeTransaction(
            title: "Salary",
            amount: 3000,
            date: "01 Jun",
            isMonthly: true,
          ),
          const IncomeTransaction(
            title: "Freelance",
            amount: 500,
            date: "28 May",
            isMonthly: false,
          ),
          const IncomeTransaction(
            title: "Investment",
            amount: 150,
            date: "25 May",
            isMonthly: false,
          ),
        ],
      );

      emit(IncomeSuccess(data));
    } catch (e) {
      emit(IncomeError("Error in fetching income overview"));
    }
  }

  
  void addIncome(AddIncomeParams params) async {
    emit(IncomeLoading());
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      emit(AddIncomeSuccess());
      
      
       fetchIncomeOverview(); 
    } catch (e) {
      emit(IncomeError("Error while adding income: ${e.toString()}"));
    }
  }
}