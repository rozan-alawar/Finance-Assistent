import 'package:flutter/material.dart';
import 'package:finance_assistent/src/core/config/theme/styles/styles.dart';
import 'package:finance_assistent/src/core/gen/app_assets.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF0F5),
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
          "About Us",
          style: TextStyles.f20(context).bold.copyWith(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 220,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF0F5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Center(
                child: Image.asset(
                  AppAssets.ASSETS_IMAGES_LOGO_PNG,
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "What you know about budget management application.",
                    style: TextStyles.f18(context).bold.copyWith(height: 1.4),
                  ),
                  const SizedBox(height: 20),

                  Text("Our Features", style: TextStyles.f16(context).bold),
                  const SizedBox(height: 15),

                  _buildFeatureItem(
                    context,
                    emoji: "⚡",
                    title: "Real-Time Expense Tracking",
                    desc:
                        "Log your daily spending in seconds. Categorize transactions instantly to see exactly where your money goes without the manual hassle.",
                  ),
                  _buildFeatureItem(
                    context,
                    emoji: "🎯",
                    title: "Smart Budgeting & Goals",
                    desc:
                        "Set personalized limits for different categories like \"Dining\" or \"Shopping\". Receive smart alerts when you're nearing your limit to help you stay on track.",
                  ),
                  _buildFeatureItem(
                    context,
                    emoji: "📱",
                    title: "Multi-Device Sync",
                    desc:
                        "Access your budget anytime, anywhere. Your data stays perfectly synced across your phone, tablet, and desktop in real-time.",
                  ),
                  _buildFeatureItem(
                    context,
                    emoji: "🔒",
                    title: "Bank-Grade Security",
                    desc:
                        "Your data is protected with end-to-end encryption and multi-factor authentication. We prioritize your financial privacy above all else.",
                  ),
                  _buildFeatureItem(
                    context,
                    emoji: "📅",
                    title: "Recurring Bill Reminders",
                    desc:
                        "Never miss a payment again. Schedule your subscriptions and fixed bills to receive automated reminders before they are due.",
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem( 
    BuildContext context, {
    required String emoji,
    required String title,
    required String desc,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.black,
                  height: 1.5,
                  fontSize: 13,
                ),
                children: [
                  TextSpan(
                    text: "$title ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: desc,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
