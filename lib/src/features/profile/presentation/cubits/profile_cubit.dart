import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/user_app_model.dart';
import '../../data/repo/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._profileRepository, {UserApp? seedUser})
    : super(
        seedUser == null ? const ProfileInitial() : ProfileLoaded(seedUser),
      );

  final ProfileRepository _profileRepository;

  void setSeedUser(UserApp user) {
    if (state is ProfileLoaded) return;
    emit(ProfileLoaded(user));
  }

  Future<void> loadProfile({bool showLoading = true}) async {
    if (showLoading) {
      emit(const ProfileLoading());
    }
    try {
      final resp = await _profileRepository.fetchProfile();
      emit(ProfileLoaded(resp.user));
    } catch (e) {
      if (state is ProfileLoaded && !showLoading) {
        return;
      }
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> updateDefaultCurrency({required String currencyId}) async {
    // await _profileRepository.updateDefaultCurrency(currencyId: currencyId);
    await loadProfile(showLoading: false);
  }

  Future<String> changePassword({
    required String id,
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) {
    return _profileRepository.changePassword(
      id: id,
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
    );
  }
}
