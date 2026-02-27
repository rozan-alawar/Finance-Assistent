import 'package:finance_assistent/src/features/income/data/repo/income_repository.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/data_source/auth_remote_data_source.dart';
import '../../features/auth/data/repo/auth_repository.dart';
import '../../features/currency/data/data_source/currency_remote_data_source.dart';
import '../../features/currency/data/repo/currency_repository.dart';
import '../../features/home/data/data_source/home_remote_data_source.dart';
import '../../features/home/data/repo/home_repository.dart';
import '../../features/home/data/repo/push_token_manager.dart';
import '../../features/income/data/data_source/income_remote_data_source.dart';
import '../../features/profile/data/data_source/profile_remote_data_source.dart';
import '../../features/profile/data/repo/profile_repository.dart';
import '../services/network/main_service/network_service.dart';
import '../services/push/fcm_token_service.dart';
import '../services/social/google_sign_in_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Services
  sl.registerLazySingleton<NetworkService>(() => NetworkService());
  sl.registerLazySingleton<GoogleSignInService>(
    () => GoogleSignInService(
      serverClientId:
          '86217792539-rdqko4nll68e498bk2ueq0au60f0al8j.apps.googleusercontent.com',
    ),
  );
  sl.registerLazySingleton<FcmTokenService>(() => FcmTokenService());

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<CurrencyRemoteDataSource>(
    () => CurrencyRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<IncomeRemoteDataSource>(
    () => IncomeRemoteDataSource(sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<CurrencyRepository>(
    () => CurrencyRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()));
  sl.registerLazySingleton<IncomeRepository>(() => IncomeRepositoryImpl(sl()));
  sl.registerLazySingleton<PushTokenManager>(() => PushTokenManager(sl()));
}
