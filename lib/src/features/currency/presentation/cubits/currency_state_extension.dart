import 'currency_state.dart';

extension CurrencyStateExtension on CurrencyState {
  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function(List currencies) loaded,
    required T Function(String message) failure,
  }) {
    if (this is CurrencyInitial) {
      return initial();
    } else if (this is CurrencyLoading) {
      return loading();
    } else if (this is CurrencyLoaded) {
      return loaded((this as CurrencyLoaded).currencies);
    } else if (this is CurrencyFailure) {
      return failure((this as CurrencyFailure).message);
    }
    throw StateError('Unknown state: $this');
  }

  T maybeWhen<T>({
    T Function()? initial,
    T Function()? loading,
    T Function(List currencies)? loaded,
    T Function(String message)? failure,
    required T Function() orElse,
  }) {
    if (this is CurrencyInitial && initial != null) {
      return initial();
    } else if (this is CurrencyLoading && loading != null) {
      return loading();
    } else if (this is CurrencyLoaded && loaded != null) {
      return loaded((this as CurrencyLoaded).currencies);
    } else if (this is CurrencyFailure && failure != null) {
      return failure((this as CurrencyFailure).message);
    }
    return orElse();
  }
}