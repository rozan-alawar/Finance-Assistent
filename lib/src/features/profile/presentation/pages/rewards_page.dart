import 'package:finance_assistent/src/core/view/component/base/image.dart';
import 'package:flutter/material.dart';
import 'package:finance_assistent/src/core/gen/app_assets.dart';
import 'package:finance_assistent/src/core/config/theme/styles/styles.dart';
import 'package:finance_assistent/src/core/utils/const/sizes.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
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
            _buildHeader(topPadding: topPadding),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingH20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Featured Rewarda", style: TextStyles.f18(context).bold),
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

  Widget _buildHeader({required double topPadding}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding + kToolbarHeight + 16,
        bottom: 24,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF2F8),
            Color(0xFFF3EEFF),
          ],
        ),
      ),
      child: Stack(
        children: [
          ..._buildConfetti(),
          Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 15),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 44,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: const AssetImage(
                        AppAssets.ASSETS_IMAGES_AVATAR_PNG,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -30,
                    child: AppAssetsSvg(
                      AppAssets.ASSETS_ICONS_REWW_SVG,
                      color: Colors.amber.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                "Total points",
                style: TextStyles.f14(context).copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    "300 points",
                    style: TextStyles.f18(context).bold,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildConfetti() {
    const color = Color(0xFFF6C445);
    Widget piece({required double top, required double left, required double size, required double angle}) {
      return Positioned(
        top: top,
        left: left,
        child: Transform.rotate(
          angle: angle,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      );
    }

    return [
      piece(top: 14, left: 24, size: 5, angle: 0.4),
      piece(top: 26, left: 80, size: 4, angle: 0.9),
      piece(top: 18, left: 150, size: 5, angle: 0.2),
      piece(top: 40, left: 210, size: 4, angle: 1.1),
      piece(top: 24, left: 290, size: 5, angle: 0.6),
      piece(top: 70, left: 44, size: 4, angle: 1.0),
      piece(top: 92, left: 110, size: 5, angle: 0.3),
      piece(top: 78, left: 180, size: 4, angle: 0.8),
      piece(top: 96, left: 260, size: 5, angle: 0.5),
      piece(top: 120, left: 24, size: 5, angle: 0.7),
      piece(top: 138, left: 92, size: 4, angle: 0.2),
      piece(top: 132, left: 230, size: 5, angle: 1.0),
      piece(top: 150, left: 302, size: 4, angle: 0.6),
    ];
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
            color: Colors.black.withValues(alpha: 0.08),
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
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(iconData, color: Colors.grey.shade700, size: 20),
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
              color: const Color(0xFFE9EDFF),
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
