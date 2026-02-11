import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_client.dart';
import '../data/data_sources/bill_remote_data_source.dart';
import '../data/repositories/bill_repository_impl.dart';
import '../presentation/bloc/bill_cubit.dart';
import '../presentation/screens/bills_screen.dart';

/// Provides the bills screen wrapped with all necessary BlocProviders
class BillInjection extends StatelessWidget {
  const BillInjection({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize data sources
    final remoteDataSource = BillRemoteDataSourceImpl(
      dio: ApiClient.dio,
    );

    // Initialize repository
    final repository = BillRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );

    return BlocProvider(
      create: (_) => BillCubit(repository: repository),
      child: const BillsScreen(),
    );
  }
}

