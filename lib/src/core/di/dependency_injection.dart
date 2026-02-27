import 'package:finance_assistent/src/core/services/push/fcm_token_service.dart';
import 'package:finance_assistent/src/core/services/social/google_sign_in_service.dart';
import 'package:finance_assistent/src/features/budget/domain/usecase/get_total_debts_usecase.dart';
import 'package:finance_assistent/src/features/budget/domain/usecase/get_total_income_usecase.dart';
import 'package:finance_assistent/src/features/home/data/data_source/home_remote_data_source.dart';
import 'package:finance_assistent/src/features/home/data/repo/home_repository.dart';
import 'package:finance_assistent/src/features/home/data/repo/push_token_manager.dart';
import 'package:finance_assistent/src/features/income/data/data_source/income_remote_data_source.dart';
import 'package:finance_assistent/src/features/income/data/repo/income_repository.dart';
import 'package:get_it/get_it.dart';

import '../../features/ask_ai/data/datasource/ai_chat_remote_datasource.dart';
import '../../features/ask_ai/data/repo/budget_repository_impl.dart'
    as ai_chat_repo;
import '../../features/ask_ai/domain/repo/ai_chat_repository.dart';
import '../../features/ask_ai/domain/usecases/get_chart_data_usecase.dart';
import '../../features/auth/data/data_source/auth_remote_data_source.dart';
import '../../features/auth/data/repo/auth_repository.dart';
import '../../features/auth/presentation/cubits/auth_cubit.dart';
import '../../features/budget/data/datasource/budget_remote_datasource.dart';
import '../../features/budget/data/repo/budget_repository_impl.dart';
import '../../features/budget/domain/repo/budget_repository.dart';
import '../../features/budget/domain/usecase/ask_ai_usecase.dart';
import '../../features/budget/domain/usecase/get_budget_summary_usecase.dart';
import '../../features/budget/domain/usecase/get_budget_usecase.dart';
import '../../features/currency/data/data_source/currency_remote_data_source.dart';
import '../../features/currency/data/repo/currency_repository.dart';
import '../../features/profile/data/data_source/profile_remote_data_source.dart';
import '../../features/profile/data/repo/profile_repository.dart';
import '../../features/profile/presentation/cubits/profile_cubit.dart';
import '../services/network/main_service/network_service.dart';

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
  sl.registerLazySingleton<BudgetRemoteDatasource>(
    () => BudgetRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AiChatRemoteDatasource>(
    () => AiChatRemoteDataSourceImpl(sl()),
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
  sl.registerLazySingleton<BudgetRepository>(() => BudgetRepositoryImpl(sl()));
  sl.registerLazySingleton<AiChatRepository>(
    () => ai_chat_repo.AiChatRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()));
  sl.registerLazySingleton<IncomeRepository>(() => IncomeRepositoryImpl(sl()));
  sl.registerLazySingleton<PushTokenManager>(() => PushTokenManager(sl()));

  // Usecases
  sl.registerLazySingleton<GetBudgetUsecase>(() => GetBudgetUsecase(sl()));
  sl.registerLazySingleton<GetBudgetSummaryUsecase>(
    () => GetBudgetSummaryUsecase(sl()),
  );
  sl.registerLazySingleton<GetChartDataUsecase>(
    () => GetChartDataUsecase(sl()),
  );
  sl.registerLazySingleton<AskAIUseCase>(() => AskAIUseCase(sl()));
  sl.registerLazySingleton<GetTotalDebtsUsecase>(
    () => GetTotalDebtsUsecase(sl()),
  );
  sl.registerLazySingleton<GetTotalIncomeUseCase>(
    () => GetTotalIncomeUseCase(sl()),
  );

  // Cubits
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl()));
  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl()));
}
