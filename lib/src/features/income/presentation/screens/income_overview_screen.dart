import 'package:finance_assistent/src/core/config/theme/styles/styles.dart';
import 'package:finance_assistent/src/core/di/dependency_injection.dart' as di;
import 'package:finance_assistent/src/core/view/component/base/button.dart';
import 'package:finance_assistent/src/core/view/component/base/custom_app_bar.dart';
import 'package:finance_assistent/src/core/view/component/base/indicator.dart';
import 'package:finance_assistent/src/core/view/component/base/safe_scaffold.dart';
import 'package:finance_assistent/src/features/income/presentation/cubit/income_cubit.dart';
import 'package:finance_assistent/src/features/income/presentation/cubit/income_state.dart';
import 'package:finance_assistent/src/features/income/presentation/screens/add_income_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/income_breakdown_section.dart';
import '../components/income_chart_section.dart';
import '../components/search_header_section.dart';
import '../components/transaction_list_item.dart';

class IncomeOverviewScreen extends StatelessWidget {
  const IncomeOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IncomeCubit(di.sl())..fetchIncomeOverview(),
      child: Builder(
        builder: (context) {
          return SafeScaffold(
            appBar: CustomAppBar(
              title: "Income Overview",
              showBackButton: true,
              onBackButtonPressed: () => Navigator.pop(context),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: AppButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddIncomeScreen(),
                      ),
                    );
                  },
                  type: AppButtonType.primary,
                  child: const Text(
                    "Add Income",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
            body: BlocBuilder<IncomeCubit, IncomeState>(
              builder: (context, state) {
                if (state is IncomeLoading) {
                  return const Center(child: LoadingAppIndicator());
                } else if (state is IncomeSuccess) {
                  final data = state.data;

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SearchHeaderSection(),
                        const SizedBox(height: 25),

                        IncomeChartSection(
                          totalIncome: data.totalIncome,
                          chartData: data.chartData,
                        ),

                        if (data.breakdownData.isNotEmpty) ...[
                          const SizedBox(height: 25),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 24,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              clipBehavior: Clip.none,
                              child: IncomeBreakdownSection(
                                breakdownData: data.breakdownData,
                              ),
                            ),
                          ),
                        ],

                        if (data.recentTransactions.isNotEmpty) ...[
                          const SizedBox(height: 35),
                          Text(
                            "Recent Income",
                            style: TextStyles.f16(context).bold,
                          ),
                          const SizedBox(height: 20),

                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.recentTransactions.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              return TransactionListItem(
                                transaction: data.recentTransactions[index],
                              );
                            },
                          ),
                        ],

                        const SizedBox(height: 120),
                      ],
                    ),
                  );
                } else if (state is IncomeError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}
