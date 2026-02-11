import '../data_source/currency_remote_data_source.dart';
import '../../domain/currency.dart';

abstract class CurrencyRepository {
  Future<List<Currency>> fetchCurrencies();
}

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteDataSource _remoteDataSource;

  CurrencyRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Currency>> fetchCurrencies() {
    return _remoteDataSource.fetchCurrencies();
  }
}
