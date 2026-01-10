import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/view/component/base/safe_scaffold.dart';
import '../components/home_shell_bottom_nav_bar.dart';
import '../utils/tab_item.dart';

class HomeShellScreen extends StatelessWidget {
  const HomeShellScreen({
    required this.navigationShell,
    super.key = const ValueKey<String>('HomeShellScreen'),
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    void onSelectTab(TabItem tab) {
      navigationShell.goBranch(tab.index);
    }

    return BackButtonListener(
      onBackButtonPressed: () async {
        final route = GoRouter.of(context).routeInformationProvider.value;
        final count = route.uri.pathSegments.length;
        if (count > 1) {
          return false;
        }
        if (navigationShell.currentIndex != 0) {
          onSelectTab(TabItem.values[0]);
          return true;
        }
        return false;
      },
      child: SafeScaffold(
        safeTop: false,
        body: navigationShell,
        bottomNavigationBar: HomeShellBottomNavBar(
          currentTab: TabItem.values[navigationShell.currentIndex],
          onSelectTab: onSelectTab,
        ),
      ),
    );
  }
}
