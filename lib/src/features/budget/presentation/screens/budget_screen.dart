import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../core/config/theme/styles/styles.dart';
import '../../../../core/routing/app_route.dart';
import '../../../../core/view/component/base/button.dart';
import '../../../../core/view/component/base/safe_scaffold.dart';
import '../components/ask_ai_section.dart';
import '../components/budget_table_section.dart';
import '../components/custom_budget_item.dart';
import '../components/search_box.dart';
import '../components/chart_section.dart';
import '../cubits/budget_cubit.dart';
import '../cubits/budget_state.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BudgetCubit(),
      lazy: false, // Create immediately for better initial performance
      child: BlocConsumer<BudgetCubit, BudgetState>(
        listener: (context, state) => {},
        builder: (context, state) {
          final cubit = context.read<BudgetCubit>();
          final gridItems = cubit.gridItems;
          return RepaintBoundary(
            child: SafeScaffold(
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(child: SearchBox()),
                    const SliverToBoxAdapter(child: SizedBox(height: 12)),

                    /// GRID
                    SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final item = gridItems[index];
                        return RepaintBoundary(
                          child: CustomBudgetItem(
                            item: item,
                            index: index,
                            gridItems: gridItems,
                          ),
                        );
                      }, childCount: gridItems.length),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1.3,
                          ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 12)),

                    /// Weekly Expense & View Report
                    SliverToBoxAdapter(
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Weekly Expense',
                                style: TextStyles.f16(context).medium,
                              ),
                              Text(
                                'From 1-6 Apr, 2026',
                                style: TextStyles.f14(context).medium.copyWith(
                                  color: ColorPalette.coldGray40,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          AppButton(
                            onPressed: () {
                              ReportsRoute().push(context);
                            },
                            type: AppButtonType.outline,
                            expanded: false,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 12,
                            ),
                            borderColor: ColorPalette.borderColor,
                            roundCorner: 25,
                            child: const Text('View Report'),
                          ),
                        ],
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 8)),

                    /// Chart
                    const SliverToBoxAdapter(child: ChartSection()),
                    const SliverToBoxAdapter(child: SizedBox(height: 12)),

                    /// Budget Table
                    const SliverToBoxAdapter(child: BudgetTableSection()),
                    const SliverToBoxAdapter(child: SizedBox(height: 8)),

                    /// ASK AI
                    const SliverToBoxAdapter(child: AskAISection()),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
