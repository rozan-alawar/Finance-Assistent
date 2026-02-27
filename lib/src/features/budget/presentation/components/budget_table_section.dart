import 'package:flutter/material.dart';

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
            child: _buildTabContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_tabController.index) {
      case 0:
        return _budgetList(count: 2);
      case 1:
        return _budgetList(count: 1);
      case 2:
        return _budgetList(count: 3);
      case 3:
        return _budgetList(count: 0);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _budgetList({required int count}) {
    if (count == 0) {
      return const Padding(
        padding: EdgeInsets.all(100),
        child: Center(child: Text('No budgets found here.')),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) => RepaintBoundary(
        child: const BudgetCard(
          username: 'Zena',
          dueDate: 'Dec 25, 2026',
          category: 'Shopping',
          amount: 250.0,
          status: 'Paid',
        ),
      ),
    );
  }
}
