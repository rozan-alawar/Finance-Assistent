part of '../../app_route.dart';

class ProfileRoute extends GoRouteData
    with $ProfileRoute {
  const ProfileRoute();

  static const routes = [
    TypedGoRoute<ProfileRoute>(path: '/profile'),
  ];

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    return null;
  }

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfilePage();
}