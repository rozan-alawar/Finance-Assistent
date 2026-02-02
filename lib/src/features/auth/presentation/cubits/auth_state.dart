import 'package:equatable/equatable.dart';

import '../../domain/user_app_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}
// ... (AuthInitial, AuthLoading, AuthGuest remain same)
class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthGuest extends AuthState {}

class AuthSuccess extends AuthState {
  final UserApp? user;
  
  const AuthSuccess({this.user});
  
  @override
  List<Object> get props => user != null ? [user!] : [];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}

class OtpSent extends AuthState {}

class OtpVerified extends AuthState {}

class PasswordResetLinkSent extends AuthState {}

class PasswordResetSuccess extends AuthState {}
