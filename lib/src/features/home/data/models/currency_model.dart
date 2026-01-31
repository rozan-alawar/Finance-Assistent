class CurrencyModel {
  final String name;
  final String code;
  final String flag; // Emoji or asset path
  final bool isAsset;

  CurrencyModel({
    required this.name,
    required this.code,
    required this.flag,
    this.isAsset = false,
  });
}
