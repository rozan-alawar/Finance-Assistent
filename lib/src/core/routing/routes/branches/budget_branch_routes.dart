part of '../../app_route.dart';


class BudgetRoute extends GoRouteData
    with $BudgetRoute {
  const BudgetRoute();

  static const routes = [
    TypedGoRoute<BudgetRoute>(path: '/budget'),
  ];

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    return null;
  }

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const BudgetScreen();
}