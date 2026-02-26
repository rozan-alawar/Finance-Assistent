part of '../../app_route.dart';

class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  static const routes = [TypedGoRoute<HomeRoute>(path: '/home')];

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    return null;
  }

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

@TypedGoRoute<NotificationRoute>(path: '/notification')
class NotificationRoute extends GoRouteData with $NotificationRoute {
  const NotificationRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const NotificationScreen();
}

@TypedGoRoute<AskAiRoute>(path: '/ask-ai')
class AskAiRoute extends GoRouteData with $AskAiRoute {
  const AskAiRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AskAiScreen();
}


@TypedGoRoute<AddDebtRoute>(path: '/add-debt')
class AddDebtRoute extends GoRouteData with $AddDebtRoute {
  const AddDebtRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AddDebtScreen();
}

@TypedGoRoute<IncomeOverviewRoute>(path: '/income-overview')
class IncomeOverviewRoute extends GoRouteData with $IncomeOverviewRoute {
  const IncomeOverviewRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const IncomeOverviewScreen();
}

@TypedGoRoute<DebtsRoute>(path: '/debt-screen')
class DebtsRoute extends GoRouteData with $DebtsRoute {
  const DebtsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DebtsScreen();
}



@TypedGoRoute<BillRoute>(path: '/bill-screen')
class BillRoute extends GoRouteData with $BillRoute {
  const BillRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const BillInjection();
}




@TypedGoRoute<ExpensesRoute>(path: '/expenses-screen')
class ExpensesRoute extends GoRouteData with $ExpensesRoute {
  const ExpensesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ExpenseInjection();
}
