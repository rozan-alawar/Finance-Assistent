import '../../../auth/domain/auth_tokens.dart';
import '../data_source/profile_remote_data_source.dart';
import '../../../auth/domain/user_app_model.dart';

abstract class ProfileRepository {
  Future<({UserApp user, AuthTokens token})> fetchProfile();
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<({UserApp user, AuthTokens token})> fetchProfile() {
    return _remoteDataSource.fetchProfile();
  }
}
