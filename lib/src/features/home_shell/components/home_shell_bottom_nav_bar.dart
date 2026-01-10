import 'package:flutter/material.dart';

import '../../../core/view/component/base/app_bottom_nav_bar.dart';
import '../utils/tab_item.dart';

class HomeShellBottomNavBar extends StatelessWidget {
  const HomeShellBottomNavBar({
    super.key,
    required this.currentTab,
    required this.onSelectTab,
  });

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return AppBottomNavBar(
      currentIndex: currentTab.index,
      onTap: (index) => onSelectTab(TabItem.values[index]),
      items: TabItem.values
          .map(
            (tabItem) => AppBottomNavBarItem(
              icon: tabItem.icon,
              selectedIcon: tabItem.selectedIcon,
              label: tabItem.getTabItemLabel(context),
            ),
          )
          .toList(),
    );
  }
}
