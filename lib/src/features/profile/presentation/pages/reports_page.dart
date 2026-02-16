import 'package:finance_assistent/src/core/view/component/base/custom_app_bar.dart';
import 'package:finance_assistent/src/core/view/component/base/safe_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:finance_assistent/src/core/gen/app_assets.dart';
import 'package:finance_assistent/src/core/config/theme/styles/styles.dart';
import 'package:finance_assistent/src/core/utils/const/sizes.dart';
import 'package:finance_assistent/src/core/utils/extensions/widget_ex.dart';
import 'package:finance_assistent/src/core/view/component/base/image.dart';
import 'dart:math';

import '../components/reports_search_bar.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      appBar: CustomAppBar(title: "Reports", showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingH20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReportsSearchBar(),
            const SizedBox(height: 20),

            _buildStatsGrid(),
            const SizedBox(height: 30),

            _buildSectionHeader("Weekly Expense", "View report"),
            Text(
              "From 1 - 6 Apr, 2024",
              style: TextStyles.f12(context).copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 15),
            _buildTimeTabs(),
            const SizedBox(height: 20),

            _buildBubbleChart(),
            _buildCategoryList(),
            const SizedBox(height: 30),

            Center(child: _buildDonutChart()),
            const SizedBox(height: 30),

            _buildBillItem(
              title: "Paid",
              subtitle: "7 bills",
              amount: "\$78.99",
              percentage: "70%",
              color: const Color(0xFF4CAF50),
              bgColor: const Color(0xFFE8F5E9),
            ),
            const SizedBox(height: 10),
            _buildBillItem(
              title: "Unpaid",
              subtitle: "7 bills",
              amount: "\$78.99",
              percentage: "70%",
              color: const Color(0xFFF44336),
              bgColor: const Color(0xFFFFEBEE),
            ),
            const SizedBox(height: 10),
            _buildBillItem(
              title: "Overdue",
              subtitle: "7 bills",
              amount: "\$78.99",
              percentage: "70%",
              color: const Color(0xFFFFC107),
              bgColor: const Color(0xFFFFF8E1),
            ),

            const SizedBox(height: 10),
            _buildBillItem(
              title: "Total Bills",
              subtitle: "Total Amount",
              amount: "10",
              percentage: "\$8767.",
              color: Color.fromARGB(255, 226, 221, 221),
              bgColor: const Color(0xFFE0E0E0),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                "Net balance",
                "\$234.783",
                // AppAssets.ASSETS_ICONS_BET_BALANCE_SVG,
                AppAssets.ASSETS_ICONS_NET_BALANCE_SVG,
                Colors.blue[100]!,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildStatCard(
                "Total expense",
                "\$8,2033",
                AppAssets.ASSETS_ICONS_TOTAL_EXPENSE_SVG,
                Colors.red[100]!,
                Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                "Total balance",
                "\$234.783",
                AppAssets.ASSETS_ICONS_NAV_BUDGET_SVG,
                Colors.blue[50]!,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildStatCard(
                "Paid",
                "\$234.783",
                AppAssets.ASSETS_ICONS_PAID_SVG,
                const Color(0xFFE8FEF1),
                const Color(0xFF00C853),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String amount,
    String iconPath,
    Color bgIconColor,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgIconColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(
              iconPath,
              color: iconColor,
              width: 20,
              height: 20,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            title,
            style: TextStyles.f12(context).copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 5),
          Text(amount, style: TextStyles.f18(context).bold),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyles.f18(context).bold),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            actionText,
            style: TextStyles.f12(context).copyWith(color: Colors.blue),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Text("Day", style: TextStyle(color: Colors.grey)),
        const Text("Week", style: TextStyle(color: Colors.grey)),
        Column(
          children: [
            const Text(
              "Month",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Container(height: 2, width: 40, color: Colors.blue),
          ],
        ),
        const Text("Year", style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildBubbleChart() {
    return SizedBox(
      height: 250,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 50,
            child: _buildBubble(
              140,
              const Color(0xFFE8EAF6),
              "48%",
              Colors.blue,
            ),
          ),
          Positioned(
            right: 40,
            top: 0,
            child: _buildBubble(
              110,
              const Color(0xFFFCE4EC),
              "32%",
              Colors.pinkAccent,
            ),
          ),
          Positioned(
            right: 100,
            bottom: 20,
            child: _buildBubble(
              80,
              const Color(0xFFFFEBEE),
              "20%",
              Colors.pinkAccent.withOpacity(0.5),
            ),
          ),
          Positioned(
            right: 0,
            top: 120,
            child: _buildBubble(
              60,
              const Color(0xFFE3F2FD),
              "16%",
              Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(double size, Color color, String text, Color textColor) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.2,
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildCategoryItem("Fookkd", "\$758.20", Colors.blue),
            ),

            Expanded(
              child: _buildCategoryItem(
                "Housing",
                "\$758.20",
                Colors.pinkAccent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        const Divider(),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildCategoryItem(
                "Transport",
                "\$758.20",
                Colors.orangeAccent,
              ),
            ),
            Expanded(
              child: _buildCategoryItem(
                "Health",
                "\$758.20",
                Colors.blueAccent,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryItem(String title, String price, Color dotColor) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: dotColor, fontSize: 12)),
            Text(
              price,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDonutChart() {
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(size: const Size(150, 150), painter: DonutChartPainter()),
          Container(
            width: 90,
            height: 90,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Text(
              "\$1,758",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillItem({
    required String title,
    required String subtitle,
    required String amount,
    required String percentage,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
          ),
          const Spacer(),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Text(
            percentage,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 25.0;

    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    paint.color = const Color(0xFF00C853);
    canvas.drawArc(rect, -pi / 2, 2.5, false, paint);

    paint.color = const Color(0xFFFF5252);
    canvas.drawArc(rect, -pi / 2 + 2.5, 1.5, false, paint);

    paint.color = const Color(0xFFFFC107);
    canvas.drawArc(rect, -pi / 2 + 4.0, 2.28, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
