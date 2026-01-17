// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_route.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $notificationRoute,
  $loginRoute,
  $homeShellRouteData,
];

RouteBase get $notificationRoute => GoRouteData.$route(
  path: '/notification',
  factory: $NotificationRoute._fromState,
);

mixin $NotificationRoute on GoRouteData {
  static NotificationRoute _fromState(GoRouterState state) =>
      const NotificationRoute();

  @override
  String get location => GoRouteData.$location('/notification');

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

RouteBase get $homeShellRouteData => StatefulShellRouteData.$route(
  restorationScopeId: HomeShellRouteData.$restorationScopeId,
  factory: $HomeShellRouteDataExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      restorationScopeId: HomeBranchData.$restorationScopeId,
      routes: [
        GoRouteData.$route(path: '/home', factory: $HomeRoute._fromState),
      ],
    ),
    StatefulShellBranchData.$branch(
      restorationScopeId: ServiceBranchData.$restorationScopeId,
      routes: [
        GoRouteData.$route(path: '/service', factory: $ServiceRoute._fromState),
      ],
    ),
    StatefulShellBranchData.$branch(
      restorationScopeId: ReminderBranchData.$restorationScopeId,
      routes: [
        GoRouteData.$route(
          path: '/reminder',
          factory: $ReminderRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      restorationScopeId: BudgetBranchData.$restorationScopeId,
      routes: [
        GoRouteData.$route(path: '/budget', factory: $BudgetRoute._fromState),
      ],
    ),
  ],
);

extension $HomeShellRouteDataExtension on HomeShellRouteData {
  static HomeShellRouteData _fromState(GoRouterState state) =>
      const HomeShellRouteData();
}

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location('/home');

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

mixin $ServiceRoute on GoRouteData {
  static ServiceRoute _fromState(GoRouterState state) => const ServiceRoute();

  @override
  String get location => GoRouteData.$location('/service');

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

mixin $ReminderRoute on GoRouteData {
  static ReminderRoute _fromState(GoRouterState state) => const ReminderRoute();

  @override
  String get location => GoRouteData.$location('/reminder');

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

mixin $BudgetRoute on GoRouteData {
  static BudgetRoute _fromState(GoRouterState state) => const BudgetRoute();

  @override
  String get location => GoRouteData.$location('/budget');

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
