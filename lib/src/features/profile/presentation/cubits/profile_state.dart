import '../../../auth/domain/user_app_model.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final UserApp user;

  const ProfileLoaded(this.user);
}

class ProfileFailure extends ProfileState {
  final String message;

  const ProfileFailure(this.message);
}
