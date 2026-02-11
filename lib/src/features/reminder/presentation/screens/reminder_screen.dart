import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:finance_assistent/src/core/gen/app_assets.dart';
import 'package:finance_assistent/src/core/config/theme/styles/styles.dart';
import 'package:finance_assistent/src/core/utils/const/sizes.dart';
import 'package:finance_assistent/src/core/utils/extensions/widget_ex.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // leading: IconButton(
        //   icon: SvgPicture.asset(
        //     AppAssets.ASSETS_ICONS_ARROW_LEFT_SVG,
        //     color: Colors.black,
        //   ),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: Text(
          "Reminder",
          style: TextStyles.f20(context).bold.copyWith(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.paddingH20,
          vertical: 20,
        ),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 20),
            _buildReminderCard(
              title: "Water Bill",
              value: "\$2,450.00",
              date: "Dec 15, 2025",
              status: "overdue",
              statusColor: const Color(0xFFFFEBEE),
              statusTextColor: const Color(0xFFF44336),
              isGroup: false,
              isSwitchedOn: false,
            ),
            const SizedBox(height: 15),
            _buildGroupReminderCard(),
            const SizedBox(height: 15),
            _buildReminderCard(
              title: "Water Bill",
              value: "\$3,200.00",
              date: "Dec 10, 2025",
              status: "overdue",
              statusColor: const Color(0xFFFFEBEE),
              statusTextColor: const Color(0xFFF44336),
              isGroup: false,
              isSwitchedOn: false,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 2,
      //   selectedItemColor: Colors.blue,
      //   unselectedItemColor: Colors.grey,
      //   type: BottomNavigationBarType.fixed,
      //   showUnselectedLabels: true,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.monetization_on),
      //       label: "Budget",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.notifications),
      //       label: "Reminder",
      //     ),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      //   ],
      // ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppAssets.ASSETS_ICONS_SEARCH_SVG,
                  color: Colors.grey,
                ),
                const SizedBox(width: 10),
                Text(
                  "Search for reminder",
                  style: TextStyles.f14(context).copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Center(
            child: SvgPicture.asset(
              AppAssets.ASSETS_ICONS_TUNE_SVG,
              color: Colors.blue,
              width: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReminderCard({
    required String title,
    required String value,
    required String date,
    required String status,
    required Color statusColor,
    required Color statusTextColor,
    required bool isGroup,
    required bool isSwitchedOn,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 242, 242, 243),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyles.f16(context).bold),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyles.f12(
                    context,
                  ).copyWith(color: statusTextColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "value: $value",
                style: TextStyles.f16(
                  context,
                ).semiBold.copyWith(color: Colors.black87),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    date,
                    style: TextStyles.f12(context).copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(),
          ),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Monthly",
                  style: TextStyles.f12(context).copyWith(color: Colors.grey),
                ),
              ),
              const Spacer(),
              _buildActionIcon(Icons.edit, Colors.grey.shade200, Colors.grey),
              const SizedBox(width: 8),
              _buildActionIcon(
                Icons.delete,
                const Color(0xFFFFEBEE),
                const Color(0xFFF44336),
              ),
              const SizedBox(width: 8),
              Switch(
                value: isSwitchedOn,
                onChanged: (val) {},
                activeColor: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGroupReminderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Apartment Expenses", style: TextStyles.f16(context).bold),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Pending",
                  style: TextStyles.f12(context).copyWith(color: const Color.fromARGB(255, 255, 0, 0)),
                ),
              ),
            ],
          ),
          Text(
            "Water Bill",
            style: TextStyles.f12(context).copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildAvatar("Gh", Colors.purple.shade100),
                  const SizedBox(width: 4),
                  _buildAvatar("Ah", Colors.blue.shade100),
                  const SizedBox(width: 4),
                  _buildAvatar("Yh", Colors.pink.shade100),
                ],
              ),
              Text(
                "INV-2025-001",
                style: TextStyles.f12(context).copyWith(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            "Total Amount",
            style: TextStyles.f12(context).copyWith(color: Colors.grey),
          ),
          Text("\$180.00", style: TextStyles.f20(context).bold),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Group Contributions",
                style: TextStyles.f12(context).copyWith(color: Colors.grey),
              ),
              Text(
                "100%",
                style: TextStyles.f12(context).copyWith(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 5),
          LinearProgressIndicator(
            value: 1.0,
            backgroundColor: Colors.grey.shade200,
            color: Colors.blue,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                "Dec 15, 2025",
                style: TextStyles.f12(context).copyWith(color: Colors.grey),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(),
          ),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Monthly",
                  style: TextStyles.f12(context).copyWith(color: Colors.grey),
                ),
              ),
              const Spacer(),
              _buildActionIcon(Icons.edit, Colors.grey.shade200, Colors.grey),
              const SizedBox(width: 8),
              _buildActionIcon(
                Icons.delete,
                const Color(0xFFFFEBEE),
                const Color(0xFFF44336),
              ),
              const SizedBox(width: 8),
              Switch(
                value: true,
                onChanged: (val) {},
                activeColor: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, Color bg, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(icon, size: 16, color: iconColor),
    );
  }

  Widget _buildAvatar(String text, Color color) {
    return CircleAvatar(
      radius: 12,
      backgroundColor: color,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
