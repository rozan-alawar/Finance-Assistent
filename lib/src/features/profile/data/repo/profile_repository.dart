import 'package:finance_assistent/src/features/auth/domain/auth_tokens.dart';

import '../../../auth/domain/user_app_model.dart';
import '../data_source/profile_remote_data_source.dart';

abstract class ProfileRepository {
  Future<({UserApp user, AuthTokens token})> fetchProfile();
  Future<String> changePassword({
    required String id,
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  });
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<({UserApp user, AuthTokens token})> fetchProfile() {
    return _remoteDataSource.fetchProfile();
  }

  @override
  Future<String> changePassword({
    required String id,
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) {
    return _remoteDataSource.changePassword(
      id: id,
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
    );
  }
}
