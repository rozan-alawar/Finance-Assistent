import '../data_source/profile_remote_data_source.dart';
import '../../../auth/domain/user_app_model.dart';

abstract class ProfileRepository {
  Future<UserApp> fetchProfile();

  Future<void> updateDefaultCurrency({required String currencyId});
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserApp> fetchProfile() {
    return _remoteDataSource.fetchProfile();
  }

  @override
  Future<void> updateDefaultCurrency({required String currencyId}) {
    return _remoteDataSource.updateDefaultCurrency(currencyId: currencyId);
  }
}
