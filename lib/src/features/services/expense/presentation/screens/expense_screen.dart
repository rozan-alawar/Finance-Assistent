import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../../core/config/theme/styles/styles.dart';
import '../../../../../core/view/component/base/custom_app_bar.dart';
import '../../../../../core/view/component/base/indicator.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_category.dart';
import '../bloc/expense_cubit.dart';
import '../bloc/expense_state.dart';
import '../widgets/balance_summary_card.dart';
import '../widgets/category_expense_tile.dart';
import '../widgets/date_filter_tabs.dart';
import '../widgets/expense_donut_chart.dart';
import '../widgets/period_navigator.dart';
import 'add_expense.dart';
import 'category_detail_screen.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseCubit>().loadExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.white,
      appBar: const CustomAppBar(title: 'Expenses', showBackButton: true),
      body: BlocBuilder<ExpenseCubit, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return const Center(child: LoadingAppIndicator());
          }

          if (state is ExpenseError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Something went wrong', style: TextStyles.f16(context)),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () =>
                        context.read<ExpenseCubit>().loadExpenses(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ExpenseLoaded) {
            return _buildContent(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: _buildAddExpenseButton(context),
    );
  }

  Widget _buildContent(BuildContext context, ExpenseLoaded state) {
    final cubit = context.read<ExpenseCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Balance Summary Card
          BalanceSummaryCard(
            totalBalance: state.totalExpenses,
            income: state.totalIncome,
            expenses: state.totalExpenses,
            percentageChange: state.percentageChange,
          ),
          const SizedBox(height: 24),

          // Date Filter Tabs
          DateFilterTabs(
            selectedFilter: state.dateFilter,
            onFilterChanged: (filter) => cubit.changeDateFilter(filter),
          ),
          const SizedBox(height: 16),

          // Period Navigator
          PeriodNavigator(
            selectedDate: state.selectedDate,
            dateFilter: state.dateFilter,
            onPrevious: () => cubit.previousPeriod(),
            onNext: () => cubit.nextPeriod(),
          ),
          const SizedBox(height: 16),

          // Donut Chart
          ExpenseDonutChart(
            expensesByCategory: state.expensesByCategory,
            totalExpenses: state.totalExpenses,
          ),
          const SizedBox(height: 24),

          // Categories Header
          Text(
            'Categories',
            style: TextStyles.f18(
              context,
            ).copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Category List
          ...ExpenseCategory.values.map((category) {
            final categoryAmount = state.expensesByCategory[category] ?? 0.0;
            final percentage = state.totalExpenses > 0
                ? (categoryAmount / state.totalExpenses) * 100
                : 0.0;
            final expenses = state.getExpensesForCategory(category);

            // Only show categories with expenses
            if (categoryAmount <= 0) return const SizedBox.shrink();

            return CategoryExpenseTile(
              category: category,
              amount: categoryAmount,
              percentage: percentage,
              expenses: expenses,
              isExpanded: false,
              onTap: () => _navigateToCategoryDetail(
                context,
                category: category,
                allExpenses: state.expenses,
                expensesByCategory: state.expensesByCategory,
              ),
            );
          }),

          // Empty state if no expenses
          if (state.expenses.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long_rounded,
                      size: 64,
                      color: ColorPalette.gray50.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No expenses yet',
                      style: TextStyles.f16(
                        context,
                      ).copyWith(color: ColorPalette.gray50),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add your first expense to get started',
                      style: TextStyles.f14(context).copyWith(
                        color: ColorPalette.gray50.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 100), // Bottom padding for FAB
        ],
      ),
    );
  }

  Widget _buildAddExpenseButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorPalette.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () => _navigateToAddExpense(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorPalette.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, size: 20),
              const SizedBox(width: 8),
              Text(
                'Add Expense',
                style: TextStyles.f16(
                  context,
                ).copyWith(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToAddExpense(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<ExpenseCubit>(),
          child: const AddExpenseScreen(),
        ),
      ),
    );
  }

  void _navigateToCategoryDetail(
    BuildContext context, {
    required ExpenseCategory category,
    required List<ExpenseEntity> allExpenses,
    required Map<ExpenseCategory, double> expensesByCategory,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategoryDetailScreen(
          initialCategory: category,
          allExpenses: allExpenses,
          expensesByCategory: expensesByCategory,
        ),
      ),
    );
  }
}
