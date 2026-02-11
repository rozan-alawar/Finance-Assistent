import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../../core/config/theme/styles/styles.dart';
import '../../../../../core/view/component/base/custom_app_bar.dart';
import '../../domain/entities/bill.dart';
import '../bloc/bill_cubit.dart';
import '../bloc/bill_state.dart';
import '../widgets/bill_search_bar.dart';
import '../widgets/bill_tab_bar.dart';
import '../widgets/group_bill_card.dart';
import '../widgets/individual_bill_card.dart';
import 'add_group_bill_screen.dart';
import 'add_individual_bill_screen.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<BillCubit>().loadBills();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.white,
      appBar: const CustomAppBar(title: 'Bills', showBackButton: true),
      body: BlocBuilder<BillCubit, BillState>(
        builder: (context, state) {
          if (state is BillLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BillError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Something went wrong', style: TextStyles.f16(context)),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyles.f14(context).copyWith(
                      color: ColorPalette.gray50,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.read<BillCubit>().loadBills(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is BillLoaded) {
            return _buildContent(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: BlocBuilder<BillCubit, BillState>(
        builder: (context, state) {
          if (state is BillLoaded) {
            return _buildAddBillButton(context, state.selectedTab);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, BillLoaded state) {
    final cubit = context.read<BillCubit>();

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: BillSearchBar(
            controller: _searchController,
            onChanged: (query) => cubit.searchBills(query),
          ),
        ),

        // Tab bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BillTabBar(
            selectedTab: state.selectedTab,
            onTabChanged: (tab) => cubit.changeTab(tab),
          ),
        ),
        const Divider(height: 1),

        // Bills list
        Expanded(
          child: _buildBillsList(context, state),
        ),
      ],
    );
  }

  Widget _buildBillsList(BuildContext context, BillLoaded state) {
    final bills = state.filteredBills;

    if (bills.isEmpty) {
      return _buildEmptyState(context, state.selectedTab);
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: bills.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final bill = bills[index];
        
        if (state.selectedTab == BillTabType.group && bill is GroupBillEntity) {
          return GroupBillCard(
            bill: bill,
            onTap: () => _onBillTap(context, bill),
          );
        }
        
        return IndividualBillCard(
          bill: bill,
          onTap: () => _onBillTap(context, bill),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, BillTabType tab) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_rounded,
              size: 64,
              color: ColorPalette.gray50.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              tab == BillTabType.individual
                  ? 'No individual bills yet'
                  : 'No group bills yet',
              style: TextStyles.f16(context).copyWith(
                color: ColorPalette.gray50,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first bill to get started',
              style: TextStyles.f14(context).copyWith(
                color: ColorPalette.gray50.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddBillButton(BuildContext context, BillTabType tab) {
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
          onPressed: () => _navigateToAddBill(context, tab),
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorPalette.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            tab == BillTabType.individual
                ? 'Create new Individual Bill'
                : 'Create new Group Bill',
            style: TextStyles.f16(context).copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void _onBillTap(BuildContext context, BillEntity bill) {
    // Navigate to bill details
    // TODO: Implement bill details screen
  }

  void _navigateToAddBill(BuildContext context, BillTabType tab) {
    final billCubit = context.read<BillCubit>();
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          if (tab == BillTabType.individual) {
            return AddIndividualBillScreen(billCubit: billCubit);
          }
          return AddGroupBillScreen(billCubit: billCubit);
        },
      ),
    );
  }
}

