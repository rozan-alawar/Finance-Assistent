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



@TypedGoRoute<RateAppRoute>(path: '/rate-app')
class RateAppRoute extends GoRouteData with $RateAppRoute {
  const RateAppRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RateUsPage();
}


@TypedGoRoute<RewardsRoute>(path: '/rewards')
class RewardsRoute extends GoRouteData with $RewardsRoute {
  const RewardsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RewardsPage();
}

@TypedGoRoute<AboutUsRoute>(path: '/about-us')
class AboutUsRoute extends GoRouteData with $AboutUsRoute {
  const AboutUsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AboutUsPage();
}

@TypedGoRoute<ReportsRoute>(path: '/reports')
class ReportsRoute extends GoRouteData with $ReportsRoute {
  const ReportsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ReportsPage();
}
