import 'package:finance_assistent/src/core/utils/const/sizes.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../core/config/theme/styles/styles.dart';
import 'percentage_scatter_chart.dart';

class ChartSection extends StatefulWidget {
  const ChartSection({super.key});

  @override
  State<ChartSection> createState() => _ChartSectionState();
}

class _ChartSectionState extends State<ChartSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final DateTime _currentDay = DateTime.now();
  final DateTime _currentWeek = DateTime.now();
  final DateTime _currentMonth = DateTime.now();
  final DateTime _currentYear = DateTime.now();

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
    return Column(
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
              _buildChartView(context, "Day", _currentDay),
              _buildChartView(context, "Week", _currentWeek),
              _buildChartView(context, "Month", _currentMonth),
              _buildChartView(context, "Year", _currentYear),
            ],
          ),
        ),
        Divider(color: ColorPalette.dividerGrey3, thickness: 0.5),
        ChartResults(
          title1: "Food",
          amonut1: 758.50,
          color1: Color(0xFF686FFF),
          title2: "Housing",
          amonut2: 758.50,
          color2: Color(0xFFFFA9DC),
        ),
        Divider(
          color: ColorPalette.dividerGrey3,
          thickness: 0.5,
          indent: 30,
          endIndent: 30,
        ),
        ChartResults(
          title1: "Transport",
          amonut1: 758.50,
          color1: Color(0xFFFFBDBC),
          title2: "Health",
          amonut2: 758.50,
          color2: Color(0xFF5792FF),
        ),
      ],
    );
  }

  Widget _buildChartView(BuildContext context, String mode, DateTime dateTime) {
    return PercentageScatterChart();
  }
}

class ChartResults extends StatelessWidget {
  final String title1;
  final double amonut1;
  final Color color1;
  final String title2;
  final double amonut2;
  final Color color2;

  const ChartResults({
    super.key,
    required this.title1,
    required this.amonut1,
    required this.color1,
    required this.title2,
    required this.amonut2,
    required this.color2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(backgroundColor: color1, radius: 4),
        const SizedBox(width: Sizes.paddingH8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title1,
              style: TextStyles.f14(context).copyWith(color: color1),
            ),
            Text(
              '\$$amonut1',
              style: TextStyles.f12(
                context,
              ).medium.copyWith(color: ColorPalette.titleGrey1),
            ),
          ],
        ),
        Spacer(),
        CircleAvatar(backgroundColor: color2, radius: 4),
        const SizedBox(width: Sizes.paddingH8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title2,
              style: TextStyles.f14(context).copyWith(color: color2),
            ),
            Text(
              '\$$amonut2',
              style: TextStyles.f12(
                context,
              ).medium.copyWith(color: ColorPalette.titleGrey1),
            ),
          ],
        ),
        title2.contains("Health")
            ? const SizedBox(width: Sizes.paddingH8)
            : SizedBox(),
      ],
    );
  }
}
