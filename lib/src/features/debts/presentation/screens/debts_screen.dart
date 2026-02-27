import 'package:finance_assistent/src/core/view/component/base/indicator.dart';
import 'package:finance_assistent/src/features/debts/presentation/cubit/debt_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/const/sizes.dart';
import '../../../../core/utils/extensions/widget_ex.dart';
import '../../../../core/utils/extensions/text_ex.dart';
import '../../../../core/config/theme/styles/styles.dart';
import '../../../../core/config/theme/app_color/extensions_color.dart';
import '../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../core/gen/app_assets.dart';
import '../../../../core/view/component/base/button.dart';
import '../../../../core/view/component/base/custom_app_bar.dart';
import '../../../../core/view/component/base/safe_scaffold.dart';
import '../../../../core/view/component/base/image.dart';
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
            if (state is DebtLoading && state is! DebtLoaded) {
              return const LoadingAppIndicator();
            }

            if (state is DebtLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => context.read<DebtCubit>().fetchDebts(
                        filter: state.selectedFilter,
                        query: state.searchQuery,
                      ),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: Sizes.marginV12),
                            TextField(
                              onChanged: (value) =>
                                  context.read<DebtCubit>().fetchDebts(
                                    filter: state.selectedFilter,
                                    query: value,
                                  ),
                              decoration: InputDecoration(
                                hintText: 'Search for Invoices',
                                hintStyle: TextStyles.f14(
                                  context,
                                ).colorWith(Colors.grey),
                                filled: true,
                                fillColor: ColorPalette.fillGrey,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 16,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 16,
                                    right: 8,
                                  ),
                                  child: AppAssetsSvg(
                                    AppAssets.ASSETS_ICONS_SEARCH_SVG,
                                  ),
                                ),
                                prefixIconConstraints: const BoxConstraints(
                                  minWidth: 40,
                                ),
                              ),
                            ).paddingSymmetric(
                              horizontal: Sizes.screenPaddingH16,
                            ),
                            const SizedBox(height: Sizes.marginV20),
                            _buildSummaryGrid(context, state.summary),
                            const SizedBox(height: Sizes.marginV24),
                            Text(
                              "Recent Debts",
                              style: TextStyles.f16(context).bold,
                            ).paddingSymmetric(
                              horizontal: Sizes.screenPaddingH16,
                            ),
                            const SizedBox(height: Sizes.marginV12),
                            _buildFilterRow(
                              context,
                              state.selectedFilter,
                              state.searchQuery,
                            ),
                            const SizedBox(height: Sizes.marginV16),
                            state.debts.isEmpty
                                ? Center(
                                    child: Text(
                                      "No results found",
                                      style: TextStyles.f14(context),
                                    ),
                                  ).paddingOnly(top: 40)
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: Sizes.screenPaddingH16,
                                    ),
                                    itemCount: state.debts.length,
                                    itemBuilder: (context, index) {
                                      final debt = state.debts[index];
                                      final cubit = context.read<DebtCubit>();

                                      return DebtListItem(
                                        model: debt,
                                        onDelete: () =>
                                            cubit.deleteDebt(debt.id),
                                        onEdit: () => _showUpdateStatusDialog(
                                          context,
                                          cubit,
                                          debt,
                                        ),
                                      );
                                    },
                                  ),
                            const SizedBox(height: Sizes.marginV20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppButton(
                    type: AppButtonType.primary,
                    onPressed: () {
                      final debtCubit = context.read<DebtCubit>();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: debtCubit,
                            child: const AddDebtScreen(),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Add Debt",
                      style: TextStyles.f14(context).medium.white,
                    ),
                  ).paddingAll(Sizes.screenPaddingH16),
                ],
              );
            }
            if (state is DebtError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showUpdateStatusDialog(
    BuildContext context,
    DebtCubit cubit,
    dynamic debt,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: ["PAID", "UNPAID", "OVERDUE"].map((status) {
          return ListTile(
            title: Text(status),
            onTap: () {
              cubit.updateDebt(debt.id, {"status": status});
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSummaryGrid(BuildContext context, Map<String, dynamic> summary) {
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
          title: "Total",
          amount: summary['totalAmount'].toString(),
          svgPath: "assets/icons/debts.svg",
          iconColor: switcher.primaryColor,
        ),
        DebtSummaryCard(
          title: "Unpaid",
          amount: summary['unpaidAmount'].toString(),
          svgPath: "assets/icons/error.svg",
          iconColor: switcher.dangerColor,
        ),
        DebtSummaryCard(
          title: "Overdue",
          amount: summary['overdueAmount'].toString(),
          svgPath: "assets/icons/warning.svg",
          iconColor: switcher.warningColor,
        ),
        DebtSummaryCard(
          title: "Paid",
          amount: summary['paidAmount'].toString(),
          svgPath: "assets/icons/done.svg",
          iconColor: switcher.successColor,
        ),
      ],
    ).paddingSymmetric(horizontal: Sizes.screenPaddingH16);
  }

  Widget _buildFilterRow(
    BuildContext context,
    String selectedFilter,
    String currentQuery,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ["All", "Paid", "Un Paid", "Overdue"].map((label) {
          bool isSelected = label == selectedFilter;
          return GestureDetector(
            onTap: () => context.read<DebtCubit>().fetchDebts(
              filter: label,
              query: currentQuery,
            ),
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
          color: isSelected ? Colors.transparent : Colors.grey.withOpacity(0.2),
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
