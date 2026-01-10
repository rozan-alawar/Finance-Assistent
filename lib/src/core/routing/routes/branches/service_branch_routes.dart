part of '../../app_route.dart';

class ServiceRoute extends GoRouteData
    with $ServiceRoute {
  const ServiceRoute();

  static const routes = [
    TypedGoRoute<ServiceRoute>(path: '/service'),
  ];

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    return null;
  }

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ServiceScreen();
}