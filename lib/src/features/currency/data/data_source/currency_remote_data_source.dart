import 'package:flutter/material.dart';

import '../../../../core/services/network/main_service/network_service.dart';
import '../../domain/currency.dart';

@immutable
class CurrencyRemoteDataSource {
  const CurrencyRemoteDataSource(this.networkService);

  final NetworkService networkService;

  String get listCurrenciesPath => '/currencies';

  Future<List<Currency>> fetchCurrencies() async {
    final response = await networkService.get<Map<String, dynamic>>(
      path: listCurrenciesPath,
    );
    final data = response.data?['data'] as List<dynamic>? ?? [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(Currency.fromMap)
        .toList();
  }
}
