import 'package:flutter/material.dart';

import '../../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../../core/config/theme/styles/styles.dart';

class BalanceSummaryCard extends StatelessWidget {
  final double totalBalance;
  final double income;
  final double expenses;
  final double percentageChange;

  const BalanceSummaryCard({
    super.key,
    required this.totalBalance,
    required this.income,
    required this.expenses,
    required this.percentageChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: ColorPalette.fillGrey,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Total Balance Section
          Text(
            'Total Balance',
            style: TextStyles.f16(context).copyWith(
              color: const Color(0xFF2D3142),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${_formatNumber(totalBalance)}',
            style: TextStyles.f24(context).copyWith(
              color: ColorPalette.primary,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${percentageChange >= 0 ? '+' : ''}${percentageChange.toStringAsFixed(1)}% vs last month',
            style: TextStyles.f14(
              context,
            ).copyWith(color: const Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 24),

          // Divider
          Container(
            height: 1,
            width: double.infinity,
            color: const Color(0xFFE5E7EB),
          ),
          const SizedBox(height: 24),

          // Income & Expenses Row
          Row(
            children: [
              // Income
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Income',
                      style: TextStyles.f14(
                        context,
                      ).copyWith(color: const Color(0xFF6B7280)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${_formatNumber(income)}',
                      style: TextStyles.f18(context).copyWith(
                        color: const Color(0xFF2D3142),
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),

              // Expenses
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Expenses',
                      style: TextStyles.f14(
                        context,
                      ).copyWith(color: const Color(0xFF6B7280)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${_formatNumber(expenses)}',
                      style: TextStyles.f18(context).copyWith(
                        color: const Color(0xFFEF4444),
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatNumber(double value) {
    if (value >= 1000) {
      return value
          .toStringAsFixed(0)
          .replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    }
    return value.toStringAsFixed(0);
  }
}
