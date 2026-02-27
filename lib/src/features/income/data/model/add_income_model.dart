class AddIncomeParams {
  final double amount;
  final String currencyId;
  final String source;
  final String description;
  final DateTime incomeDate;
  final Map<String, dynamic>? assetId;
  final IncomeRecurringParams? recurring;

  AddIncomeParams({
    required this.amount,
    required this.currencyId,
    required this.source,
    required this.description,
    required this.incomeDate,
    this.assetId,
    this.recurring,
  });

  Map<String, dynamic> toJson() {
    return {
      "amount": amount.toStringAsFixed(2),
      "currencyId": currencyId,
      "source": source,
      "description": description,
      "incomeDate": incomeDate.toIso8601String().split('T')[0],
      "assetId": assetId ?? {},
      if (recurring != null) "recurring": recurring!.toJson(),
    };
  }
}

class IncomeRecurringParams {
  final String frequency;
  final DateTime? endAt;

  IncomeRecurringParams({
    required this.frequency,
    this.endAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "frequency": frequency.toUpperCase(),
      if (endAt != null) "endAt": endAt!.toIso8601String().split('T')[0],
    };
  }
}