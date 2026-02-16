import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/view/component/base/indicator.dart';
import '../data/data_sources/bill_local_data_source.dart';
import '../data/data_sources/bill_remote_data_source.dart';
import '../data/repositories/bill_repository_impl.dart';
import '../presentation/bloc/bill_cubit.dart';
import '../presentation/screens/bills_screen.dart';

/// Provides the bills screen wrapped with all necessary BlocProviders
class BillInjection extends StatelessWidget {
  const BillInjection({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: LoadingAppIndicator()),
          );
        }

        final sharedPreferences = snapshot.data!;

        // Initialize data sources
        final localDataSource = BillLocalDataSourceImpl(
          sharedPreferences: sharedPreferences,
        );
        final remoteDataSource = BillRemoteDataSourceImpl(
          dio: ApiClient.dio,
        );

        // Initialize repository with both data sources
        final repository = BillRepositoryImpl(
          remoteDataSource: remoteDataSource,
          localDataSource: localDataSource,
        );

        return BlocProvider(
          create: (_) => BillCubit(repository: repository),
          child: const BillsScreen(),
        );
      },
    );
  }
}
