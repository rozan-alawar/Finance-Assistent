import 'package:flutter/material.dart';

import '../../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../../core/config/theme/styles/styles.dart';
import '../bloc/expense_state.dart';

class PeriodNavigator extends StatelessWidget {
  final DateTime selectedDate;
  final DateFilterType dateFilter;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const PeriodNavigator({
    super.key,
    required this.selectedDate,
    required this.dateFilter,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left_rounded),
          color: ColorPalette.gray60,
        ),
        Text(
          _getPeriodLabel(),
          style: TextStyles.f16(context).copyWith(fontWeight: FontWeight.w500),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right_rounded),
          color: ColorPalette.gray60,
        ),
      ],
    );
  }

  String _getPeriodLabel() {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    switch (dateFilter) {
      case DateFilterType.day:
        return '${selectedDate.day} ${months[selectedDate.month - 1]} ${selectedDate.year}';
      case DateFilterType.week:
        final weekStart = selectedDate.subtract(
          Duration(days: selectedDate.weekday - 1),
        );
        final weekEnd = weekStart.add(const Duration(days: 6));
        return '${weekStart.day} - ${weekEnd.day} ${months[weekEnd.month - 1]}';
      case DateFilterType.month:
        return months[selectedDate.month - 1];
      case DateFilterType.year:
        return '${selectedDate.year}';
    }
  }
}
