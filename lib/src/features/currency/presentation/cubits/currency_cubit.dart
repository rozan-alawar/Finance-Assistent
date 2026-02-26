import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repo/currency_repository.dart';
import 'currency_state.dart';

class CurrencyCubit extends Cubit<CurrencyState> {
  CurrencyCubit(this._currencyRepository) : super(const CurrencyInitial());

  final CurrencyRepository _currencyRepository;

  Future<void> loadCurrencies() async {
    emit(const CurrencyLoading());
    try {
      final currencies = await _currencyRepository.fetchCurrencies();
      emit(CurrencyLoaded(currencies));
    } catch (e) {
      emit(CurrencyFailure(e.toString()));
    }
  }
}
