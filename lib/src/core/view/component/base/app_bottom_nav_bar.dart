
import 'package:flutter/material.dart';

import '../../../config/theme/app_color/extensions_color.dart';
import '../../../config/theme/styles/styles.dart';
import '../../../utils/const/sizes.dart';
import '../../../utils/extensions/text_ex.dart';

class AppBottomNavBarItem {
  const AppBottomNavBarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final Widget icon;
  final Widget selectedIcon;
  final String label;
}

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  final int currentIndex;
  final List<AppBottomNavBarItem> items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      height: 70 + bottomPadding,
      padding: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Sizes.radius30),
          topRight: Radius.circular(Sizes.radius30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = currentIndex == index;
          return Expanded(
            child: _NavBarItem(
              icon: isSelected ? item.selectedIcon : item.icon,
              label: item.label,
              isSelected: isSelected,
              onTap: () => onTap(index),
            ),
          );
        }),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final Widget icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            SizedBox(height: Sizes.marginV4),
            Text(
              label,
              style: TextStyles.f12(context).medium.colorWith(
                    isSelected
                        ? appSwitcherColors(context).primaryColor
                        : appSwitcherColors(context)
                            .neutralColors
                            .shade900
                            .withValues(alpha: 0.6),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
