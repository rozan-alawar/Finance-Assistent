import 'package:get_it/get_it.dart';
import '../../features/ask_ai/data/datasource/ai_chat_remote_datasource.dart';
import '../../features/ask_ai/data/repo/budget_repository_impl.dart';
import '../../features/ask_ai/domain/repo/ai_chat_repository.dart';
import '../../features/ask_ai/domain/usecases/get_chart_data_usecase.dart';
import '../../features/auth/data/data_source/auth_remote_data_source.dart';
import '../../features/auth/data/repo/auth_repository.dart';
import '../../features/currency/data/data_source/currency_remote_data_source.dart';
import '../../features/currency/data/repo/currency_repository.dart';
import '../../features/profile/data/data_source/profile_remote_data_source.dart';
import '../../features/profile/data/repo/profile_repository.dart';
import '../../features/budget/data/datasource/budget_remote_datasource.dart';
import '../../features/budget/data/repo/budget_repository_impl.dart';
import '../../features/budget/domain/repo/budget_repository.dart';
import '../../features/budget/domain/usecase/ask_ai_usecase.dart';
import '../../features/budget/domain/usecase/get_budget_usecase.dart';
import '../services/network/main_service/network_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Services
  sl.registerLazySingleton<NetworkService>(() => NetworkService());

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

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<CurrencyRepository>(
    () => CurrencyRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<BudgetRepository>(() => BudgetRepositoryImpl(sl()));
  sl.registerLazySingleton<AiChatRepository>(() => AiChatRepositoryImpl(sl()));

  // Usecases
  sl.registerLazySingleton<GetBudgetUsecase>(() => GetBudgetUsecase(sl()));
  sl.registerLazySingleton<GetChartDataUsecase>(
    () => GetChartDataUsecase(sl()),
  );
  sl.registerLazySingleton<AskAIUseCase>(() => AskAIUseCase(sl()));
}
