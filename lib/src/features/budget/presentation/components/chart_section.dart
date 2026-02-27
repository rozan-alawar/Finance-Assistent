import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/theme/app_color/color_palette.dart';
import '../../domain/entity/category_chart_date.dart';
import '../cubits/budget_cubit.dart';
import '../cubits/budget_state.dart';
import 'percentage_scatter_chart.dart';

class ChartSection extends StatefulWidget {
  const ChartSection({super.key});

  @override
  State<ChartSection> createState() => _ChartSectionState();
}

class _ChartSectionState extends State<ChartSection>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  final DateTime _currentDay = DateTime.now();
  final DateTime _currentWeek = DateTime.now();
  final DateTime _currentMonth = DateTime.now();
  final DateTime _currentYear = DateTime.now();

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
    return BlocBuilder<BudgetCubit, BudgetState>(
      builder: (context, state) {
        final cubit = context.read<BudgetCubit>();
        final chartData = cubit.chartData;

        return RepaintBoundary(
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                labelColor: ColorPalette.primary,
                unselectedLabelColor: Colors.grey,
                dividerHeight: 0,
                indicatorColor: ColorPalette.primary,
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: "Day"),
                  Tab(text: "Week"),
                  Tab(text: "Month"),
                  Tab(text: "Year"),
                ],
              ),
              SizedBox(
                height: 270,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildChartView(context, "Day", _currentDay, chartData),
                    _buildChartView(context, "Week", _currentWeek, chartData),
                    _buildChartView(context, "Month", _currentMonth, chartData),
                    _buildChartView(context, "Year", _currentYear, chartData),
                  ],
                ),
              ),
              const Divider(color: ColorPalette.dividerGrey3, thickness: 0.5),
              Column(
                children: List.generate(chartData.length, (index) {
                  final item = chartData[index];
                  return Row(
                    children: [
                      CircleAvatar(backgroundColor: item.color, radius: 4),
                      SizedBox(width: 8),
                      Text(item.title),
                      Spacer(),
                      Text('\$${item.amount}'),
                    ],
                  );
                }),
              ),
              const Divider(
                color: ColorPalette.dividerGrey3,
                thickness: 0.5,
                indent: 30,
                endIndent: 30,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChartView(
    BuildContext context,
    String mode,
    DateTime dateTime,
    List<CategoryChartData> chartData,
  ) {
    return PercentageScatterChart(data: chartData);
  }
}
