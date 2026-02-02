import '../data_source/auth_remote_data_source.dart';
import '../../domain/user_app_model.dart';
import '../../domain/auth_tokens.dart';

abstract class AuthRepository {
  Future<({UserApp user, AuthTokens token})> login({required String email, required String password});
  
  Future<({UserApp user, AuthTokens token})> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    bool rememberMe = true,
  });

  Future<({UserApp user, AuthTokens token})> verifySocialToken({
    required String token,
    required String socialType, 
    String? authorizationCode,
  });

  Future<bool> checkEmail({required String email});
  
  Future<void> sendOtp({required String email});
  
  Future<String> verifyOtp({required String email, required String otp});
  
  Future<void> resetPassword({required String resetToken, required String newPassword});
  
  Future<UserApp> updateUserCurrency({
    required String userId,
    required String currency,
    required String token,
  });
  
  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<({UserApp user, AuthTokens token})> login({required String email, required String password}) {
    return _remoteDataSource.login(email: email, password: password);
  }

  @override
  Future<({UserApp user, AuthTokens token})> register({required String email, required String password, required String fullName, String? phone, bool rememberMe = true}) {
    return _remoteDataSource.register(email: email, password: password, fullName: fullName, phone: phone, rememberMe: rememberMe);
  }

  @override
  Future<bool> checkEmail({required String email}) {
    return _remoteDataSource.checkEmail(email: email);
  }

  @override
  Future<void> resetPassword({required String resetToken, required String newPassword}) {
    return _remoteDataSource.resetPassword(resetToken: resetToken, newPassword: newPassword);
  }

  @override
  Future<void> sendOtp({required String email}) {
    return _remoteDataSource.sendOtp(email: email);
  }

  @override
  Future<UserApp> updateUserCurrency({
    required String userId,
    required String currency,
    required String token,
  }) {
    return _remoteDataSource.updateUserCurrency(userId: userId, currency: currency, token: token);
  }

  @override
  Future<String> verifyOtp({required String email, required String otp}) {
    return _remoteDataSource.verifyOtp(email: email, otp: otp);
  }

  @override
  Future<({UserApp user, AuthTokens token})> verifySocialToken({required String token, required String socialType, String? authorizationCode}) {
    return _remoteDataSource.verifySocialToken(token: token, socialType: socialType, authorizationCode: authorizationCode);
  }
  
  @override
  Future<void> logout() async {
    // Implement logout logic, typically clearing local storage
    // You might inject HiveService here or just handle it in Controller/Cubit
  }
}
