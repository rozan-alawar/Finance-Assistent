import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../../core/config/theme/styles/styles.dart';
import '../../domain/entities/bill.dart';

class GroupBillCard extends StatelessWidget {
  final GroupBillEntity bill;
  final VoidCallback? onTap;

  const GroupBillCard({
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      if (bill.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          bill.subtitle!,
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
            const SizedBox(height: 12),

            // Participants avatars and invoice number
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ParticipantAvatars(
                  participants: bill.participants,
                  maxDisplay: 3,
                ),
                if (bill.invoiceNumber != null)
                  Text(
                    bill.invoiceNumber!,
                    style: TextStyles.f12(context).copyWith(
                      color: ColorPalette.gray50,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Amount row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Amount',
                        style: TextStyles.f12(context).copyWith(
                          color: ColorPalette.gray50,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${_formatAmount(bill.amount)}',
                        style: TextStyles.f16(context).copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D3142),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Your share',
                        style: TextStyles.f12(context).copyWith(
                          color: ColorPalette.gray50,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${_formatAmount(bill.userShare)}',
                        style: TextStyles.f16(context).copyWith(
                          fontWeight: FontWeight.bold,
                          color: ColorPalette.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Contribution progress
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Group Contributions',
                      style: TextStyles.f12(context).copyWith(
                        color: ColorPalette.gray50,
                      ),
                    ),
                    Text(
                      '${bill.contributionPercentage.toStringAsFixed(0)}%',
                      style: TextStyles.f12(context).copyWith(
                        color: ColorPalette.gray50,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: bill.contributionPercentage / 100,
                    backgroundColor: ColorPalette.coldGray10,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      ColorPalette.primary,
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Date
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

class _ParticipantAvatars extends StatelessWidget {
  final List participants;
  final int maxDisplay;

  const _ParticipantAvatars({
    required this.participants,
    this.maxDisplay = 3,
  });

  @override
  Widget build(BuildContext context) {
    final displayCount = participants.length > maxDisplay 
        ? maxDisplay 
        : participants.length;
    final remaining = participants.length - maxDisplay;

    return SizedBox(
      height: 32,
      child: Stack(
        children: [
          ...List.generate(displayCount, (index) {
            final participant = participants[index];
            return Positioned(
              left: index * 20.0,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorPalette.white,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: participant.avatarUrl != null
                      ? Image.network(
                          participant.avatarUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _InitialsAvatar(
                            initials: participant.initials,
                          ),
                        )
                      : _InitialsAvatar(initials: participant.initials),
                ),
              ),
            );
          }),
          if (remaining > 0)
            Positioned(
              left: displayCount * 20.0,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorPalette.coldGray20,
                  border: Border.all(
                    color: ColorPalette.white,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '+$remaining',
                    style: TextStyles.f10(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: ColorPalette.gray50,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  final String initials;

  const _InitialsAvatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorPalette.primary.withValues(alpha: 0.2),
      child: Center(
        child: Text(
          initials,
          style: TextStyles.f12(context).copyWith(
            fontWeight: FontWeight.w600,
            color: ColorPalette.primary,
          ),
        ),
      ),
    );
  }
}

