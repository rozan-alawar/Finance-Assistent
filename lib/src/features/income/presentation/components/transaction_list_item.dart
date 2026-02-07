import 'package:finance_assistent/src/features/income/data/model/income_transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 

class TransactionListItem extends StatelessWidget {
  final IncomeTransaction transaction;
  const TransactionListItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    const Color titleColor = Color(0xFF1C1A1A);
    const Color subtitleColor = Color(0xFFAEAEAE);

    final formatter = NumberFormat('#,###');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    color: titleColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.date,
                  style: const TextStyle(color: subtitleColor, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "\$${formatter.format(transaction.amount)}",
                style: const TextStyle(
                  color: titleColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              _buildTag(transaction.isMonthly),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(bool isMonthly) {
    final Color tagTextColor = isMonthly
        ? const Color(0xFFFD9AA0)
        : const Color(0xFF5792FF);
    final Color tagBgColor = isMonthly
        ? const Color(0xFFFD9AA0).withOpacity(0.15)
        : const Color(0xFF5792FF).withOpacity(0.10);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: tagBgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 6, color: tagTextColor),
          const SizedBox(width: 5),
          Text(
            isMonthly ? "Monthly" : "One-time",
            style: TextStyle(
              color: tagTextColor,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}