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

@TypedGoRoute<SelectCurrencyRoute>(path: '/select-currency')
class SelectCurrencyRoute extends GoRouteData with $SelectCurrencyRoute {
  final String? activeCurrencyCode;
  final bool? isOnboarding;
  final bool? isSignup;
  const SelectCurrencyRoute({this.activeCurrencyCode, this.isOnboarding, this.isSignup});

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SelectCurrencyScreen(
        activeCurrencyCode: activeCurrencyCode,
        isOnboarding: isOnboarding ?? false,
        isSignup: isSignup ?? false,
      );
}

@TypedGoRoute<AddDebtRoute>(path: '/add-debt')
class AddDebtRoute extends GoRouteData with $AddDebtRoute {
  const AddDebtRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AddDebtScreen();
}
