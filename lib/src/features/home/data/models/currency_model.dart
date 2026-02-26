import 'package:finance_assistent/src/core/gen/app_assets.dart';

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

  static List<CurrencyModel> get allCurrencies => [
    CurrencyModel(name: "United States _ (US Dollar)", code: "USD", flag: AppAssets.ASSETS_ICONS_US_FLAG_SVG, isAsset: true),
    CurrencyModel(name: "United Kingdom _(British Pound Sterling)", code: "GBP", flag: "🇬🇧"),
    CurrencyModel(name: "European Union _ (Euro)", code: "EUR", flag: "🇪🇺"),
    CurrencyModel(name: "Saudi Arabia _ ( Saudi Riyal)", code: "SAR", flag: "🇸🇦"),
    CurrencyModel(name: "United Arab Emirates _ ( UAE Dirham)", code: "AED", flag: "🇦🇪"),
    CurrencyModel(name: "Jordan _ ( Jordanian Dinar)", code: "JOD", flag: "🇯🇴"),
    CurrencyModel(name: "Japan _ (Japanese Yen)", code: "JPY", flag: "🇯🇵"),
  ];

  static CurrencyModel getByCode(String code) {
    return allCurrencies.firstWhere(
      (c) => c.code == code,
      orElse: () => allCurrencies.first,
    );
  }
}
