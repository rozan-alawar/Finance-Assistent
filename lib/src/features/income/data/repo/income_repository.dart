import 'package:finance_assistent/src/features/income/data/data_source/income_remote_data_source.dart';
import 'package:finance_assistent/src/features/income/data/model/add_income_model.dart';
import 'package:finance_assistent/src/features/income/data/model/income_model.dart';
import 'package:finance_assistent/src/features/income/data/model/income_summary_model.dart';

abstract class IncomeRepository {
  Future<IncomeSummaryModel> getSummary();
  Future<List<IncomeModel>> getIncomes({int page = 1, int limit = 10});
  Future<void> createIncome(AddIncomeParams params);
}

class IncomeRepositoryImpl implements IncomeRepository {
  final IncomeRemoteDataSource _remoteDataSource;

  IncomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<IncomeSummaryModel> getSummary() => _remoteDataSource.getSummary();

  @override
  Future<List<IncomeModel>> getIncomes({int page = 1, int limit = 10}) async {
    final response = await _remoteDataSource.getIncomes(
      page: page,
      limit: limit,
    );
    return response.data;
  }

  @override
  Future<void> createIncome(AddIncomeParams params) {
    return _remoteDataSource.createIncome(params.toJson());
  }
}
