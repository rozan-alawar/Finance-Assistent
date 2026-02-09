import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/user_app_model.dart';
import '../../data/repo/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(
    this._profileRepository, {
    UserApp? seedUser,
  }) : super(seedUser == null ? const ProfileInitial() : ProfileLoaded(seedUser));

  final ProfileRepository _profileRepository;

  Future<void> loadProfile({bool showLoading = true}) async {
    if (showLoading) {
      emit(const ProfileLoading());
    }
    try {
      final data = await _profileRepository.fetchProfile();
      emit(ProfileLoaded(data.user));
    } catch (e) {
      if (state is ProfileLoaded && !showLoading) {
        return;
      }
      emit(ProfileFailure(e.toString()));
    }
  }
}
