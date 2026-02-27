import 'package:finance_assistent/src/features/home/data/repo/home_repository.dart';

class PushTokenManager {
  final HomeRepository repository;
  PushTokenManager(this.repository);

  Future<void> register(String token, {String platform = 'mobile'}) {
    return repository.registerToken(token, platform: platform);
  }

  Future<void> remove(String token) {
    return repository.removeToken(token);
  }
}
