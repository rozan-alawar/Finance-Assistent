import '../../domain/currency.dart';

abstract class CurrencyState {
  const CurrencyState();
}

class CurrencyInitial extends CurrencyState {
  const CurrencyInitial();
}

class CurrencyLoading extends CurrencyState {
  const CurrencyLoading();
}

class CurrencyLoaded extends CurrencyState {
  final List<Currency> currencies;

  const CurrencyLoaded(this.currencies);
}

class CurrencyFailure extends CurrencyState {
  final String message;

  const CurrencyFailure(this.message);
}
