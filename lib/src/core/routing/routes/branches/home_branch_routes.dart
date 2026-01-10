part of '../../app_route.dart';

class HomeRoute extends GoRouteData
    with $HomeRoute {
  const HomeRoute();

  static const routes = [
    TypedGoRoute<HomeRoute>(path: '/home'),
  ];

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    return null;
  }

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const HomeScreen();
}