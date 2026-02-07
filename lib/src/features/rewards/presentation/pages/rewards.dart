import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:finance_assistent/src/core/gen/app_assets.dart';
import 'package:finance_assistent/src/core/config/theme/styles/styles.dart';
import 'package:finance_assistent/src/core/utils/const/sizes.dart';
import 'package:finance_assistent/src/core/utils/extensions/widget_ex.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({Key? key}) : super(key: key);

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Rewards",
          style: TextStyles.f20(context).bold.copyWith(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingH20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Featured Rewards", style: TextStyles.f18(context).bold),
                  const SizedBox(height: 15),

                  _buildRewardCard(
                    title: "Premium Theme Pack",
                    subtitle: "Unlock exclusive badge for your profile",
                    points: "500 points",
                    iconData: Icons.palette_outlined,
                    iconColor: Colors.pinkAccent,
                    iconBgColor: const Color(0xFFFFEBEE),
                  ),
                  const SizedBox(height: 15),

                  _buildRewardCard(
                    title: "Budget Master Badge",
                    subtitle: "Unlock exclusive badge for your profile",
                    points: "500 points",
                    iconData: Icons.verified_user_outlined,
                    iconColor: Colors.blueAccent,
                    iconBgColor: const Color(0xFFE3F2FD),
                  ),
                  const SizedBox(height: 15),

                  _buildRewardCard(
                    title: "Smart insight Report",
                    subtitle: "Unlock exclusive badge for your profile",
                    points: "500 points",
                    iconData: Icons.lightbulb_outline,
                    iconColor: Colors.pink,
                    iconBgColor: const Color(0xFFFCE4EC),
                  ),
                  const SizedBox(height: 30),

                  Text(
                    "How To Earn More Points",
                    style: TextStyles.f18(context).bold,
                  ),
                  const SizedBox(height: 15),

                  _buildEarnPointCard(
                    title: "Log expensive daily",
                    subtitle: "Unlock exclusive badge for your profile",
                    pointsReward: "+30 pts",
                    iconData: Icons.calendar_today,
                  ),
                  const SizedBox(height: 15),

                  _buildEarnPointCard(
                    title: "Add income",
                    subtitle: "Unlock exclusive badge for your profile",
                    pointsReward: "+50 pts",
                    iconData: Icons.add,
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 100, bottom: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFF0F5), Colors.white],
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    "https://i.pravatar.cc/150?img=32",
                  ),
                ),
              ),

              const Positioned(
                top: 0,
                child: Icon(Icons.emoji_events, color: Colors.amber, size: 30),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            "Total points",
            style: TextStyles.f14(context).copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 24),
              const SizedBox(width: 5),
              Text(
                "300 points",
                style: TextStyles.f24(
                  context,
                ).bold.copyWith(color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard({
    required String title,
    required String subtitle,
    required String points,
    required IconData iconData,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(iconData, color: iconColor, size: 24),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyles.f16(context).bold),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyles.f12(
                        context,
                      ).copyWith(color: Colors.grey, height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 5),
                  Text(points, style: TextStyles.f14(context).bold),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F51B5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 0,
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Claim Now",
                  style: TextStyles.f12(context).copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEarnPointCard({
    required String title,
    required String subtitle,
    required String pointsReward,
    required IconData iconData,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: Colors.grey, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyles.f14(context).bold),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyles.f10(context).copyWith(color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE8EAF6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              pointsReward,
              style: TextStyles.f12(
                context,
              ).bold.copyWith(color: const Color(0xFF3F51B5)),
            ),
          ),
        ],
      ),
    );
  }
}
