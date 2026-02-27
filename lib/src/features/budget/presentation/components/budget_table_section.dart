import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/bill_data.dart';
import '../cubits/budget_cubit.dart';
import '../cubits/budget_state.dart';
import '../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../core/config/theme/styles/styles.dart';
import 'budget_card.dart';

class BudgetTableSection extends StatefulWidget {
  const BudgetTableSection({super.key});

  @override
  State<BudgetTableSection> createState() => _BudgetTableSectionState();
}

class _BudgetTableSectionState extends State<BudgetTableSection>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Budget Table', style: TextStyles.f18(context).medium),
          TabBar(
            controller: _tabController,
            labelColor: ColorPalette.white,
            unselectedLabelColor: Colors.grey,
            dividerHeight: 0,
            indicator: BoxDecoration(
              shape: BoxShape.rectangle,
              color: ColorPalette.primary,
              borderRadius: BorderRadius.circular(25),
            ),
            indicatorPadding: const EdgeInsets.all(4),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(text: "All"),
              Tab(text: "Paid"),
              Tab(text: "Unpaid"),
              Tab(text: "Overdue"),
            ],
          ),

          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: BlocBuilder<BudgetCubit, BudgetState>(
              builder: (context, state) {
                if (state is BillsLoadingState) {
                  return const Padding(
                    padding: EdgeInsets.all(50.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is BillsErrorState) {
                  return Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Center(child: Text(state.exception)),
                  );
                } else if (state is BillsLoadedState) {
                  return _buildTabContent(state.bills);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(List<BillData> allBills) {
    List<BillData> filtered = [];
    switch (_tabController.index) {
      case 0:
        filtered = allBills;
        break;
      case 1:
        filtered = allBills
            .where((b) => b.status?.toLowerCase() == 'paid')
            .toList();
        break;
      case 2:
        filtered = allBills
            .where((b) => b.status?.toLowerCase() == 'unpaid')
            .toList();
        break;
      case 3:
        filtered = allBills
            .where((b) => b.status?.toLowerCase() == 'overdue')
            .toList();
        break;
    }
    return _budgetList(filtered);
  }

  Widget _budgetList(List<BillData> bills) {
    if (bills.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(100),
        child: Center(child: Text('No budgets found here.')),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bills.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final bill = bills[index];
        return RepaintBoundary(
          child: BudgetCard(
            username: 'Username',
            dueDate: bill.date ?? 'Unknown',
            category: bill.name ?? 'Unknown',
            amount: double.tryParse(bill.amount ?? '0') ?? 0.0,
            status: bill.status ?? 'Unknown',
          ),
        );
      },
    );
  }
}
