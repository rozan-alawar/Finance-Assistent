import 'package:finance_assistent/src/core/config/theme/styles/styles.dart';
import 'package:finance_assistent/src/core/gen/app_assets.dart';
import 'package:finance_assistent/src/core/utils/extensions/text_ex.dart';
import 'package:finance_assistent/src/core/view/component/base/image.dart';
import 'package:finance_assistent/src/core/routing/app_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_assistent/src/core/di/dependency_injection.dart';
import 'package:finance_assistent/src/features/currency/presentation/cubits/currency_cubit.dart';
import 'package:finance_assistent/src/features/currency/presentation/cubits/currency_state.dart';
import 'package:finance_assistent/src/features/currency/data/repo/currency_repository.dart';
import 'package:finance_assistent/src/features/currency/domain/currency.dart';
import 'package:finance_assistent/src/core/services/local_storage/hive_service.dart';

class SelectCurrencyScreen extends StatefulWidget {
  final String? activeCurrencyCode;
  final bool isOnboarding;
  final bool isSignup;
  const SelectCurrencyScreen({super.key, this.activeCurrencyCode, this.isOnboarding = false, this.isSignup = false});

  @override
  State<SelectCurrencyScreen> createState() => _SelectCurrencyScreenState();
}

class _SelectCurrencyScreenState extends State<SelectCurrencyScreen> {
  List<Currency> _allCurrencies = const [];

  List<Currency> _filteredCurrencies = [];
  final TextEditingController _searchController = TextEditingController();
  Currency? _selectedCurrency;

  @override
  void initState() {
    super.initState();
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
    return BlocProvider(
      create: (_) => CurrencyCubit(sl<CurrencyRepository>())..loadCurrencies(),
      child: BlocBuilder<CurrencyCubit, CurrencyState>(
        builder: (context, state) {
          if (state is CurrencyLoaded) {
            _allCurrencies = state.currencies;
            if (_searchController.text.isEmpty) {
              _filteredCurrencies = _allCurrencies;
            } else {
              _filteredCurrencies = _allCurrencies
                  .where((currency) =>
                      currency.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                      currency.code.toLowerCase().contains(_searchController.text.toLowerCase()))
                  .toList();
            }
            if (_selectedCurrency == null) {
              if (widget.activeCurrencyCode != null) {
                _selectedCurrency = _allCurrencies.firstWhere(
                  (c) => c.code == widget.activeCurrencyCode,
                  orElse: () => _allCurrencies.first,
                );
              } else {
                _selectedCurrency = _allCurrencies.isNotEmpty ? _allCurrencies.first : null;
              }
            }
          }

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
                  child: state is CurrencyLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.separated(
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
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        "${currency.name} (${currency.code})",
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
                        if (_selectedCurrency == null) return;
                        // Save currency locally only
                        await HiveService.put(
                          HiveService.settingsBoxName,
                          'currency_code',
                          _selectedCurrency!.code,
                        );
                        await HiveService.put(
                          HiveService.settingsBoxName,
                          'currency_selected',
                          true,
                        );
                        // Navigate to home (only available after signup)
                        if (context.mounted) {
                          const HomeRoute().go(context);
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
        },
      ),
    );
  }
}
