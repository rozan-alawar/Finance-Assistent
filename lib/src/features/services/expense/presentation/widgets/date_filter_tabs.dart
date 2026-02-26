import 'package:flutter/material.dart';

import '../../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../../core/config/theme/styles/styles.dart';
import '../bloc/expense_state.dart';

class DateFilterTabs extends StatelessWidget {
  final DateFilterType selectedFilter;
  final ValueChanged<DateFilterType> onFilterChanged;

  const DateFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: DateFilterType.values.map((filter) {
        final isSelected = filter == selectedFilter;
        return GestureDetector(
          onTap: () => onFilterChanged(filter),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? ColorPalette.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: isSelected
                  ? Border.all(color: ColorPalette.primary, width: 1.5)
                  : null,
            ),
            child: Text(
              _getFilterLabel(filter),
              style: TextStyles.f14(context).copyWith(
                color: isSelected ? ColorPalette.primary : ColorPalette.gray50,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getFilterLabel(DateFilterType filter) {
    switch (filter) {
      case DateFilterType.day:
        return 'Day';
      case DateFilterType.week:
        return 'Week';
      case DateFilterType.month:
        return 'Month';
      case DateFilterType.year:
        return 'Year';
    }
  }
}
