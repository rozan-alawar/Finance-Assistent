import 'package:flutter/material.dart';

import '../../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../../core/config/theme/styles/styles.dart';
import '../bloc/bill_state.dart';

class BillTabBar extends StatelessWidget {
  final BillTabType selectedTab;
  final ValueChanged<BillTabType> onTabChanged;

  const BillTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TabItem(
            title: 'Individual Bills',
            isSelected: selectedTab == BillTabType.individual,
            onTap: () => onTabChanged(BillTabType.individual),
          ),
        ),
        Expanded(
          child: _TabItem(
            title: 'Group Bills',
            isSelected: selectedTab == BillTabType.group,
            onTap: () => onTabChanged(BillTabType.group),
          ),
        ),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              title,
              style: TextStyles.f14(context).copyWith(
                color: isSelected ? ColorPalette.primary : ColorPalette.gray50,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          Container(
            height: 2,
            color: isSelected ? ColorPalette.primary : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

