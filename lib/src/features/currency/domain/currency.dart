class Currency {
  final String id;
  final String code;
  final String symbol;
  final String name;

  const Currency({
    required this.id,
    required this.code,
    required this.symbol,
    required this.name,
  });

  factory Currency.fromMap(Map<String, dynamic> map) {
    return Currency(
      id: map['id'] as String,
      code: map['code'] as String,
      symbol: map['symbol'] as String,
      name: map['name'] as String,
    );
  }
}
