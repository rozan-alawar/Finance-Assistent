part of '../app_route.dart';

@TypedStatefulShellRoute<HomeShellRouteData>(
  branches: [
    TypedStatefulShellBranch<HomeBranchData>(
      routes: HomeRoute.routes,
    ),
    TypedStatefulShellBranch<BudgetBranchData>(
      routes: BudgetRoute.routes,
    ),

    TypedStatefulShellBranch<ReminderBranchData>(
      routes: ReminderRoute.routes,
    ),

    TypedStatefulShellBranch<ProfileBranchData>(
      routes: ProfileRoute.routes,
    ),

  ],
)
class HomeShellRouteData extends StatefulShellRouteData {
  const HomeShellRouteData();

  @override
  Page<void> pageBuilder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return FadePageRoute(
      pageKey: state.pageKey,
      child: HomeShellScreen(navigationShell: navigationShell),
    );
  }

  static const String $restorationScopeId = 'home_shell';
}

class HomeBranchData extends StatefulShellBranchData {
  const HomeBranchData();

  static const String $restorationScopeId = 'home_branch';
}

class ProfileBranchData extends StatefulShellBranchData {
  const ProfileBranchData();

  static const String $restorationScopeId = 'profile_branch';
}

class ReminderBranchData extends StatefulShellBranchData {
  const ReminderBranchData();

  static const String $restorationScopeId =
      'reminder_branch';
}

class BudgetBranchData extends StatefulShellBranchData {
  const BudgetBranchData();

  static const String $restorationScopeId = 'budget_branch';
}
