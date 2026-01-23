part of '../app_route.dart';

@TypedGoRoute<LoginRoute>(
  path: '/login',
  routes: [
    TypedGoRoute<RegisterRoute>(path: 'register'),
    TypedGoRoute<ForgetPasswordRoute>(path: 'forget-password'),
    TypedGoRoute<OtpVerificationRoute>(path: 'verify-otp'),
    TypedGoRoute<ResetPasswordRoute>(path: 'reset-password'),
  ],
)
class LoginRoute extends GoRouteData with $LoginRoute {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LoginScreen();
}

class RegisterRoute extends GoRouteData with $RegisterRoute {
  const RegisterRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RegisterScreen();
}

class ForgetPasswordRoute extends GoRouteData with $ForgetPasswordRoute {
  const ForgetPasswordRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ForgetPasswordScreen();
}

class OtpVerificationRoute extends GoRouteData with $OtpVerificationRoute {
  const OtpVerificationRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const OtpVerificationScreen();
}

class ResetPasswordRoute extends GoRouteData with $ResetPasswordRoute {
  const ResetPasswordRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ResetPasswordScreen();
}

@TypedGoRoute<OnboardingRoute>(path: '/onboarding')
class OnboardingRoute extends GoRouteData with $OnboardingRoute {
  const OnboardingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const OnboardingScreen();
}
