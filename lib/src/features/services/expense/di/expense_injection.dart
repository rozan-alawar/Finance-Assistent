import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/view/component/base/indicator.dart';
import '../data/data_sources/expense_local_data_source.dart';
import '../data/data_sources/expense_remote_data_source.dart';
import '../data/repositories/expense_repository_impl.dart';
import '../presentation/bloc/expense_cubit.dart';
import '../presentation/screens/expense_screen.dart';

/// Provides the expense screen wrapped with all necessary BlocProviders
class ExpenseInjection extends StatelessWidget {
  const ExpenseInjection({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            body: Center(child: LoadingAppIndicator()),
          );
        }

        final sharedPreferences = snapshot.data!;

        // Initialize data sources
        final localDataSource = ExpenseLocalDataSourceImpl(
          sharedPreferences: sharedPreferences,
        );
        final remoteDataSource = ExpenseRemoteDataSourceImpl(
          dio: ApiClient.dio,
        );

        // Initialize repository with both data sources
        final repository = ExpenseRepositoryImpl(
          remoteDataSource: remoteDataSource,
          localDataSource: localDataSource,
        );

        return BlocProvider(
          create: (_) => ExpenseCubit(repository: repository),
          child: const ExpenseScreen(),
        );
      },
    );
  }
}

/// Provides the Add Expense screen wrapped with necessary dependencies
/// Use this when navigating to Add Expense from outside the Expense feature
class AddExpenseInjection extends StatelessWidget {
  final ExpenseCubit? existingCubit;

  const AddExpenseInjection({super.key, this.existingCubit});

  @override
  Widget build(BuildContext context) {
    if (existingCubit != null) {
      return BlocProvider.value(
        value: existingCubit!,
        child: const ExpenseScreen(),
      );
    }

    return const ExpenseInjection();
  }
}
