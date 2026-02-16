import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../../core/config/theme/styles/styles.dart';
import '../../domain/entities/bill.dart';

class IndividualBillCard extends StatelessWidget {
  final BillEntity bill;
  final VoidCallback? onTap;

  const IndividualBillCard({
    super.key,
    required this.bill,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorPalette.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ColorPalette.coldGray10,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: Bill name and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bill.name,
                        style: TextStyles.f16(context).copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3142),
                        ),
                      ),
                      if (bill.invoiceNumber != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          bill.invoiceNumber!,
                          style: TextStyles.f12(context).copyWith(
                            color: ColorPalette.gray50,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                _StatusBadge(status: bill.status),
              ],
            ),
            const SizedBox(height: 16),
            
            // Amount and date row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${_formatAmount(bill.amount)}',
                  style: TextStyles.f18(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3142),
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: ColorPalette.gray50,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('MMM dd, yyyy').format(bill.dueDate),
                      style: TextStyles.f12(context).copyWith(
                        color: ColorPalette.gray50,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000) {
      return amount.toStringAsFixed(2).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    }
    return amount.toStringAsFixed(2);
  }
}

class _StatusBadge extends StatelessWidget {
  final dynamic status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status.backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.name,
        style: TextStyles.f12(context).copyWith(
          color: status.color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

