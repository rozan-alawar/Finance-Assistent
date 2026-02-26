import '../../domain/home_overview.dart';
import '../data_source/home_remote_data_source.dart';

abstract class HomeRepository {
  Future<HomeOverview> getOverview();
  Future<void> registerToken(String token, {String platform});
  Future<void> removeToken(String token);
}

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remote;
  HomeRepositoryImpl(this._remote);

  @override
  Future<HomeOverview> getOverview() => _remote.getOverview();

  @override
  Future<void> registerToken(String token, {String platform = 'mobile'}) {
    return _remote.registerPushToken(token: token, platform: platform);
  }

  @override
  Future<void> removeToken(String token) {
    return _remote.removePushToken(token: token);
  }
}
