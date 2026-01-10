part of '../app_route.dart';

@TypedStatefulShellRoute<HomeShellRouteData>(
  branches: [
    TypedStatefulShellBranch<HomeBranchData>(
      routes: HomeRoute.routes,
    ),
    TypedStatefulShellBranch<ServiceBranchData>(
      routes: ServiceRoute.routes,
    ),
    TypedStatefulShellBranch<ReminderBranchData>(
      routes: ReminderRoute.routes,
    ),
    TypedStatefulShellBranch<BudgetBranchData>(
      routes: BudgetRoute.routes,
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

class ServiceBranchData extends StatefulShellBranchData {
  const ServiceBranchData();

  static const String $restorationScopeId = 'service_branch';
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
