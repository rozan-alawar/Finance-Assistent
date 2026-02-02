import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/local_storage/hive_service.dart';
import '../../domain/user_app_model.dart';
import '../../data/repo/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  
  // Temporary storage for multi-step flows
  String? _resetEmail;
  String? _resetOtp;

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> checkSession() async {
    final isGuest = HiveService.get(
      HiveService.settingsBoxName,
      'isGuest',
      defaultValue: false,
    );
     // You might also check for existing token here
     final token = HiveService.get(HiveService.settingsBoxName, 'token');

    if (token != null && token.isNotEmpty && isGuest == false) {
       // Valid user session
       final userMap = HiveService.get(HiveService.settingsBoxName, 'user');
       UserApp? user;
       if (userMap != null) {
         try {
           user = UserApp.fromMap(Map<String, dynamic>.from(userMap));
         } catch (e) {
           // Handle parse error or migration issues
         }
       }
       emit(AuthSuccess(user: user));
    } else if (isGuest) {
      // Guest session
      emit(AuthGuest());
    } else {
      // No session
      emit(AuthInitial());
    }
  }


  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final result = await _authRepository.register(
        email: email, 
        password: password, 
        fullName: name, 
        phone: phone
      );
      
      await _saveSession(result.token.token, result.user);
      
      await HiveService.put(
        HiveService.settingsBoxName,
        'currency_selected',
        false,
      );
      emit(AuthSuccess(user: result.user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final result = await _authRepository.login(email: email, password: password);
      await _saveSession(result.token.token, result.user);
      emit(AuthSuccess(user: result.user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
  
  // =====================================================
  //                    Social Login
  // =====================================================
  
  Future<void> socialLogin({required String token, required String socialType, String? authorizationCode}) async {
    emit(AuthLoading());
    try {
      final result = await _authRepository.verifySocialToken(
        token: token, 
        socialType: socialType,
        authorizationCode: authorizationCode,
      );
      await _saveSession(result.token.token, result.user);
      emit(AuthSuccess(user: result.user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // =====================================================
  //                    Forgot Password Flow
  // =====================================================

  Future<void> sendOtp({required String email}) async {
    emit(AuthLoading());
    try {
      await _authRepository.sendOtp(email: email);
      _resetEmail = email; // Store for next steps
      emit(OtpSent());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> verifyOtp({required String code}) async {
    if (_resetEmail == null) {
      emit(const AuthFailure("Email not found. Please request OTP again."));
      return;
    }
    emit(AuthLoading());
    try {
      await _authRepository.verifyOtp(email: _resetEmail!, otp: code);
      _resetOtp = code; // Store for reset step
      emit(OtpVerified());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
  
  Future<void> resetPassword({required String newPassword}) async {
    if (_resetEmail == null || _resetOtp == null) {
      emit(const AuthFailure("Session expired. Please start over."));
      return;
    }
    emit(AuthLoading());
    try {
      await _authRepository.resetPassword(resetToken: _resetEmail!, newPassword: newPassword);
      emit(PasswordResetSuccess());
      // Cleanup
      _resetEmail = null;
      _resetOtp = null;
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> loginAsGuest() async {
    emit(AuthLoading());
    try {
      await HiveService.put(
        HiveService.settingsBoxName,
        'isGuest',
        true,
      );
      emit(AuthGuest());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
  
  Future<void> _saveSession(String token, UserApp user) async {
    await HiveService.put(HiveService.settingsBoxName, 'token', token);
    await HiveService.put(HiveService.settingsBoxName, 'isGuest', false);
    await HiveService.put(HiveService.settingsBoxName, 'user', user.toMap());
  }
}
