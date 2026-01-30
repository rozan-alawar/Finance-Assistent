// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_route.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $notificationRoute,
  $selectCurrencyRoute,
  $loginRoute,
  $homeShellRouteData,
  $onboardingRoute,
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

RouteBase get $selectCurrencyRoute => GoRouteData.$route(
  path: '/select-currency',
  factory: $SelectCurrencyRoute._fromState,
);

mixin $SelectCurrencyRoute on GoRouteData {
  static SelectCurrencyRoute _fromState(GoRouterState state) =>
      SelectCurrencyRoute(
        activeCurrencyCode: state.uri.queryParameters['active-currency-code'],
        isOnboarding: _$convertMapValue(
          'is-onboarding',
          state.uri.queryParameters,
          _$boolConverter,
        ),
      );

  SelectCurrencyRoute get _self => this as SelectCurrencyRoute;

  @override
  String get location => GoRouteData.$location(
    '/select-currency',
    queryParams: {
      if (_self.activeCurrencyCode != null)
        'active-currency-code': _self.activeCurrencyCode,
      if (_self.isOnboarding != null)
        'is-onboarding': _self.isOnboarding!.toString(),
    },
  );

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

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T? Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

bool _$boolConverter(String value) {
  switch (value) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw UnsupportedError('Cannot convert "$value" into a bool.');
  }
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

RouteBase get $onboardingRoute => GoRouteData.$route(
  path: '/onboarding',
  factory: $OnboardingRoute._fromState,
);

mixin $OnboardingRoute on GoRouteData {
  static OnboardingRoute _fromState(GoRouterState state) =>
      const OnboardingRoute();

  @override
  String get location => GoRouteData.$location('/onboarding');

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
