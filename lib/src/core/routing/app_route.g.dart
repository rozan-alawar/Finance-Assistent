// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_route.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$loginRoute];

RouteBase get $loginRoute => GoRouteData.$route(
  path: '/login',
  factory: $LoginRoute._fromState,
  routes: [
    GoRouteData.$route(path: 'register', factory: $RegisterRoute._fromState),
    GoRouteData.$route(
      path: 'forget-password',
      factory: $ForgetPasswordRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'verify-otp',
      factory: $OtpVerificationRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'reset-password',
      factory: $ResetPasswordRoute._fromState,
    ),
  ],
);

mixin $LoginRoute on GoRouteData {
  static LoginRoute _fromState(GoRouterState state) => const LoginRoute();

  @override
  String get location => GoRouteData.$location('/login');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $RegisterRoute on GoRouteData {
  static RegisterRoute _fromState(GoRouterState state) => const RegisterRoute();

  @override
  String get location => GoRouteData.$location('/login/register');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ForgetPasswordRoute on GoRouteData {
  static ForgetPasswordRoute _fromState(GoRouterState state) =>
      const ForgetPasswordRoute();

  @override
  String get location => GoRouteData.$location('/login/forget-password');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $OtpVerificationRoute on GoRouteData {
  static OtpVerificationRoute _fromState(GoRouterState state) =>
      const OtpVerificationRoute();

  @override
  String get location => GoRouteData.$location('/login/verify-otp');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ResetPasswordRoute on GoRouteData {
  static ResetPasswordRoute _fromState(GoRouterState state) =>
      const ResetPasswordRoute();

  @override
  String get location => GoRouteData.$location('/login/reset-password');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
