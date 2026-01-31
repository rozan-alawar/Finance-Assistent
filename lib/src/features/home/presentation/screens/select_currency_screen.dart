import 'package:finance_assistent/src/core/config/theme/app_color/extensions_color.dart';
import 'package:finance_assistent/src/core/config/theme/styles/styles.dart';
import 'package:finance_assistent/src/core/gen/app_assets.dart';
import 'package:finance_assistent/src/core/utils/const/sizes.dart';
import 'package:finance_assistent/src/core/utils/extensions/text_ex.dart';
import 'package:finance_assistent/src/core/utils/extensions/widget_ex.dart';
import 'package:finance_assistent/src/core/view/component/base/image.dart';
import 'package:finance_assistent/src/core/routing/app_route.dart';
import 'package:finance_assistent/src/core/services/local_storage/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:finance_assistent/src/features/home/data/models/currency_model.dart';

class SelectCurrencyScreen extends StatefulWidget {
  final String? activeCurrencyCode;
  final bool isOnboarding;
  const SelectCurrencyScreen({super.key, this.activeCurrencyCode, this.isOnboarding = false});

  @override
  State<SelectCurrencyScreen> createState() => _SelectCurrencyScreenState();
}

class _SelectCurrencyScreenState extends State<SelectCurrencyScreen> {
  final List<CurrencyModel> _allCurrencies = [
    CurrencyModel(name: "United States _ (US Dollar)", code: "USD", flag: AppAssets.ASSETS_ICONS_US_FLAG_SVG, isAsset: true),
    CurrencyModel(name: "United Kingdom _(British Pound Sterling)", code: "GBP", flag: "🇬🇧"),
    CurrencyModel(name: "European Union _ (Euro)", code: "EUR", flag: "🇪🇺"),
    CurrencyModel(name: "Saudi Arabia _ ( Saudi Riyal)", code: "SAR", flag: "🇸🇦"),
    CurrencyModel(name: "United Arab Emirates _ ( UAE Dirham)", code: "AED", flag: "🇦🇪"),
    CurrencyModel(name: "Jordan _ ( Jordanian Dinar)", code: "JOD", flag: "🇯🇴"),
    CurrencyModel(name: "Japan _ (Japanese Yen)", code: "JPY", flag: "🇯🇵"),
  ];

  List<CurrencyModel> _filteredCurrencies = [];
  TextEditingController _searchController = TextEditingController();
  CurrencyModel? _selectedCurrency;

  @override
  void initState() {
    super.initState();
    _filteredCurrencies = _allCurrencies;
    
    if (widget.activeCurrencyCode != null) {
      _selectedCurrency = _allCurrencies.firstWhere(
        (c) => c.code == widget.activeCurrencyCode,
        orElse: () => _allCurrencies.first,
      );
    } else {
      _selectedCurrency = _allCurrencies.first;
    }
  }

  void _filterCurrencies(String query) {
    setState(() {
      _filteredCurrencies = _allCurrencies
          .where((currency) =>
              currency.name.toLowerCase().contains(query.toLowerCase()) ||
              currency.code.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text("Select Currency"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterCurrencies,
              decoration: InputDecoration(
                hintText: "Search for Currency",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: AppAssetsSvg(AppAssets.ASSETS_ICONS_SEARCH_SVG, color: Colors.grey),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Color(0xFFF9F9FA),
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _filteredCurrencies.length,
              separatorBuilder: (context, index) => SizedBox(height: 8),
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final currency = _filteredCurrencies[index];
                final isSelected = _selectedCurrency == currency;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCurrency = currency;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFF3F51B5) : Color(0xFFF9F9FA),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        if (currency.isAsset)
                          ClipOval(
                            child: AppAssetsSvg(currency.flag, width: 24, height: 24),
                          )
                        else
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.transparent,
                            child: Text(currency.flag, style: TextStyle(fontSize: 20)),
                          ),
                        
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            currency.name,
                            style: TextStyles.f14(context).medium.colorWith(
                                  isSelected ? Colors.white : Colors.black,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () async {
                  if (widget.isOnboarding) {
                    await HiveService.put(
                      HiveService.settingsBoxName,
                      'currency_selected',
                      true,
                    );
                     const HomeRoute().go(context);
                  } else {
                    context.pop(_selectedCurrency);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3F51B5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  "Continue",
                  style: TextStyles.f16(context).medium.colorWith(Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
