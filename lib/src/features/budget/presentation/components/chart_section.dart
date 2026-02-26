import 'package:finance_assistent/src/core/utils/const/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../core/config/theme/styles/styles.dart';
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
              if (chartData.isNotEmpty)
                ChartResults(
                  title1: chartData[0].title,
                  amonut1: chartData[0].amount,
                  color1: chartData[0].color,
                  title2: chartData.length > 1 ? chartData[1].title : null,
                  amonut2: chartData.length > 1 ? chartData[1].amount : null,
                  color2: chartData.length > 1 ? chartData[1].color : null,
                ),
              const Divider(
                color: ColorPalette.dividerGrey3,
                thickness: 0.5,
                indent: 30,
                endIndent: 30,
              ),
              if (chartData.length > 2)
                ChartResults(
                  title1: chartData[2].title,
                  amonut1: chartData[2].amount,
                  color1: chartData[2].color,
                  title2: chartData.length > 3 ? chartData[3].title : null,
                  amonut2: chartData.length > 3 ? chartData[3].amount : null,
                  color2: chartData.length > 3 ? chartData[3].color : null,
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

class ChartResults extends StatelessWidget {
  final String title1;
  final double amonut1;
  final Color color1;
  final String? title2;
  final double? amonut2;
  final Color? color2;

  const ChartResults({
    super.key,
    required this.title1,
    required this.amonut1,
    required this.color1,
    this.title2,
    this.amonut2,
    this.color2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(backgroundColor: color1, radius: 4),
        const SizedBox(width: Sizes.paddingH8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title1,
                style: TextStyles.f14(context).copyWith(color: color1),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '\$$amonut1',
                style: TextStyles.f12(
                  context,
                ).medium.copyWith(color: ColorPalette.titleGrey1),
              ),
            ],
          ),
        ),
        if (title2 != null) ...[
          const SizedBox(width: Sizes.paddingH8),
          CircleAvatar(backgroundColor: color2, radius: 4),
          const SizedBox(width: Sizes.paddingH8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title2!,
                  style: TextStyles.f14(context).copyWith(color: color2),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '\$$amonut2',
                  style: TextStyles.f12(
                    context,
                  ).medium.copyWith(color: ColorPalette.titleGrey1),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
