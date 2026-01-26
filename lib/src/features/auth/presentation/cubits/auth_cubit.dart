import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_assistent/src/core/services/local_storage/hive_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  Future<void> checkSession() async {
    final isGuest = HiveService.get(
      HiveService.settingsBoxName,
      'isGuest',
      defaultValue: false,
    );

    if (isGuest) {
      emit(AuthGuest());
    } else {
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
      await Future.delayed(const Duration(seconds: 2));
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      await Future.delayed(const Duration(seconds: 2));
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> sendOtp({required String phone}) async {
    emit(AuthLoading());
    try {
      await Future.delayed(const Duration(seconds: 2));
      emit(OtpSent());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> verifyOtp({required String code}) async {
    emit(AuthLoading());
    try {
      if (code == '1234') {
        // Mock verification
        await Future.delayed(const Duration(seconds: 2));
        emit(OtpVerified());
      } else {
        emit(const AuthFailure("Invalid OTP"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> forgetPassword({required String email}) async {
    emit(AuthLoading());
    try {
      await Future.delayed(const Duration(seconds: 2));
      emit(PasswordResetLinkSent());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> resetPassword({required String newPassword}) async {
    emit(AuthLoading());
    try {
      await Future.delayed(const Duration(seconds: 2));
      emit(PasswordResetSuccess());
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

}
