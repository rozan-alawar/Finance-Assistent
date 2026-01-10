part of '../../app_route.dart';

class ReminderRoute extends GoRouteData
    with $ReminderRoute {
  const ReminderRoute();

  static const routes = [
    TypedGoRoute<ReminderRoute>(path: '/reminder'),
  ];

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    return null;
  }

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ReminderScreen();
}