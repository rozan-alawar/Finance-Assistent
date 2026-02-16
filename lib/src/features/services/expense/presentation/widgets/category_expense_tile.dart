import 'package:flutter/material.dart';

import '../../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../../core/config/theme/styles/styles.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_category.dart';

class CategoryExpenseTile extends StatelessWidget {
  final ExpenseCategory category;
  final double amount;
  final double percentage;
  final List<ExpenseEntity> expenses;
  final bool isExpanded;
  final VoidCallback onTap;

  const CategoryExpenseTile({
    super.key,
    required this.category,
    required this.amount,
    required this.percentage,
    required this.expenses,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Row
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Category Icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: category.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(category.icon, color: category.color, size: 24),
                  ),
                  const SizedBox(width: 12),

                  // Category Name & Percentage
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: TextStyles.f16(
                            context,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '${percentage.toStringAsFixed(0)}%',
                              style: TextStyles.f12(
                                context,
                              ).copyWith(color: ColorPalette.gray50),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: percentage / 100,
                                  backgroundColor: category.color.withValues(
                                    alpha: 0.2,
                                  ),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    category.color,
                                  ),
                                  minHeight: 4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Amount
                  Text(
                    '${amount.toStringAsFixed(1)}\$',
                    style: TextStyles.f16(
                      context,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 8),

                  // Forward Arrow (navigates to detail)
                  const Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: ColorPalette.gray50,
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

