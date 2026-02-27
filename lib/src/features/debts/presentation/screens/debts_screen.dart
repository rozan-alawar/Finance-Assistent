import 'package:finance_assistent/src/core/view/component/base/indicator.dart';
import 'package:finance_assistent/src/features/debts/presentation/components/debts_search_bar.dart';
import 'package:finance_assistent/src/features/debts/presentation/cubit/debt_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/const/sizes.dart';
import '../../../../core/utils/extensions/widget_ex.dart';
import '../../../../core/utils/extensions/text_ex.dart';
import '../../../../core/config/theme/styles/styles.dart';
import '../../../../core/config/theme/app_color/extensions_color.dart';
import '../../../../core/view/component/base/button.dart';
import '../../../../core/view/component/base/custom_app_bar.dart';
import '../../../../core/view/component/base/safe_scaffold.dart';
import '../components/debt_list_item.dart';
import '../components/debt_summary_card.dart';
import 'add_debt_screen.dart';

class DebtsScreen extends StatelessWidget {
  const DebtsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DebtCubit()..fetchDebts(),
      child: SafeScaffold(
        appBar: CustomAppBar(
          title: "Debts",
          showBackButton: true,
          onBackButtonPressed: () => Navigator.of(context).pop(),
        ),
        body: BlocBuilder<DebtCubit, DebtState>(
          builder: (context, state) {
            if (state is! DebtLoaded) {
              return const LoadingAppIndicator();
            }

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        DebtSearchBar().paddingSymmetric(horizontal: Sizes.paddingH16),

                        const SizedBox(height: Sizes.marginV20),

                        _buildSummaryGrid(context),

                        const SizedBox(height: Sizes.marginV24),
                        Text(
                          "Recent Debts",
                          style: TextStyles.f16(context).bold,
                        ).paddingSymmetric(horizontal: Sizes.screenPaddingH16),

                        const SizedBox(height: Sizes.marginV12),

                        _buildFilterRow(context, state.selectedFilter),

                        const SizedBox(height: Sizes.marginV16),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.screenPaddingH16,
                          ),
                          itemCount: state.debts.length,
                          itemBuilder: (context, index) =>
                              DebtListItem(model: state.debts[index]),
                        ),
                        const SizedBox(height: Sizes.marginV20),
                      ],
                    ),
                  ),
                ),

                AppButton(
                  type: AppButtonType.primary,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddDebtScreen(),
                    ),
                  ),
                  child: Text(
                    "Add Debt",
                    style: TextStyles.f14(context).medium.white,
                  ),
                ).paddingAll(Sizes.screenPaddingH16),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryGrid(BuildContext context) {
    final switcher = appSwitcherColors(context);
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.25,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        DebtSummaryCard(
          title: "Total Debts",
          amount: "234.783",
          svgPath: "assets/icons/debts.svg",
          iconColor: switcher.primaryColor,
        ),
        DebtSummaryCard(
          title: "Unpaid",
          amount: "8,203",
          svgPath: "assets/icons/error.svg",
          iconColor: switcher.dangerColor,
        ),
        DebtSummaryCard(
          title: "Overdue",
          amount: "1,450",
          svgPath: "assets/icons/warning.svg",
          iconColor: switcher.warningColor,
        ),
        DebtSummaryCard(
          title: "Paid",
          amount: "12,000",
          svgPath: "assets/icons/done.svg",
          iconColor: switcher.successColor,
        ),
      ],
    ).paddingSymmetric(horizontal: Sizes.screenPaddingH16);
  }

  Widget _buildFilterRow(BuildContext context, String selectedFilter) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ["All", "Paid", "Un Paid", "Overdue"].map((label) {
          bool isSelected = label == selectedFilter;
          return GestureDetector(
            onTap: () => context.read<DebtCubit>().fetchDebts(filter: label),
            child: _buildFilterWidget(context, label, isSelected: isSelected),
          );
        }).toList(),
      ).paddingOnly(left: Sizes.screenPaddingH16),
    );
  }

  Widget _buildFilterWidget(
    BuildContext context,
    String label, {
    bool isSelected = false,
  }) {
    final switcher = appSwitcherColors(context);
    final common = appCommonUIColors(context);

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? switcher.primaryColor : common.white,
        borderRadius: BorderRadius.circular(Sizes.radius20),
        border: Border.all(
          color: isSelected
              ? Colors.transparent
              : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        label,
        style: TextStyles.f12(
          context,
        ).semiBold.colorWith(isSelected ? Colors.white : Colors.grey.shade600),
      ),
    );
  }
}
