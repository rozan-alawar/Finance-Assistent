import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/view/component/base/app_bottom_nav_bar.dart';
import '../../../core/view/component/base/login_required_dialog.dart';
import '../../auth/presentation/cubits/auth_cubit.dart';
import '../../auth/presentation/cubits/auth_state.dart';
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
    final authState = context.watch<AuthCubit>().state;
    final isUnauthenticated = authState is AuthGuest || authState is AuthInitial;

    return AppBottomNavBar(
      currentIndex: currentTab.index,
      onTap: (index) {
        final tab = TabItem.values[index];
        if (tab == TabItem.profile && isUnauthenticated) {
          showLoginRequiredDialog(
            context,
            title: 'Profile',
            message: 'Log in to access your profile and view your account details.',
          );
          return;
        }
        onSelectTab(tab);
      },
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
