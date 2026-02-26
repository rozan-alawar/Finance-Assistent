import 'package:finance_assistent/src/core/config/theme/app_color/extensions_color.dart';
import 'package:finance_assistent/src/core/config/theme/styles/styles.dart';
import 'package:finance_assistent/src/core/di/dependency_injection.dart';
import 'package:finance_assistent/src/core/gen/app_assets.dart';
import 'package:finance_assistent/src/core/routing/app_route.dart';
import 'package:finance_assistent/src/core/services/local_storage/hive_service.dart';
import 'package:finance_assistent/src/core/utils/const/sizes.dart';
import 'package:finance_assistent/src/core/utils/extensions/text_ex.dart';
import 'package:finance_assistent/src/core/utils/extensions/widget_ex.dart';
import 'package:finance_assistent/src/core/view/component/base/custom_toast.dart';
import 'package:finance_assistent/src/core/view/component/base/image.dart';
import 'package:finance_assistent/src/core/view/component/base/safe_scaffold.dart';
import 'package:finance_assistent/src/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:finance_assistent/src/features/auth/presentation/cubits/auth_state.dart';
import 'package:finance_assistent/src/features/currency/data/repo/currency_repository.dart';
import 'package:finance_assistent/src/features/currency/domain/currency.dart';
import 'package:finance_assistent/src/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:finance_assistent/src/features/profile/presentation/cubits/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/view/component/base/indicator.dart';
import '../components/logout_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<List<Currency>>? _currenciesFuture;
  List<Currency> _currenciesCache = const [];
  Currency? _selectedCurrencyOverride;

  void _ensureProfileLoaded() {
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthSuccess) return;

    final profileCubit = context.read<ProfileCubit>();
    final seedUser = authState.user;
    if (seedUser != null) {
      profileCubit.setSeedUser(seedUser);
    }

    if (profileCubit.state is ProfileInitial) {
      profileCubit.loadProfile(showLoading: seedUser == null);
    }
  }

  @override
  void initState() {
    super.initState();
    _currenciesFuture = sl<CurrencyRepository>().fetchCurrencies().then((list) {
      _currenciesCache = list;
      return list;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureProfileLoaded());
  }

  Currency? _resolveCurrency(String idOrCode) {
    if (idOrCode.isEmpty || _currenciesCache.isEmpty) return null;

    for (final c in _currenciesCache) {
      if (c.id == idOrCode) return c;
    }
    for (final c in _currenciesCache) {
      if (c.code == idOrCode) return c;
    }
    return null;
  }

  Future<void> _pickCurrency(
    BuildContext context,
    String currentIdOrCode,
  ) async {
    final selected = await showModalBottomSheet<Currency>(
      backgroundColor: appCommonUIColors(context).white,
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: FutureBuilder<List<Currency>>(
              future: _currenciesFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        snapshot.error.toString(),
                        style: TextStyles.f14(context).medium,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return const Center(child: LoadingAppIndicator());
                }

                final currencies = snapshot.data ?? const <Currency>[];
                final current =
                    _selectedCurrencyOverride ??
                    _resolveCurrency(currentIdOrCode);

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Select Currency',
                              style: TextStyles.f18(context).bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(sheetContext),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: currencies.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final c = currencies[index];
                          final isSelected = current?.id == c.id;
                          return ListTile(
                            onTap: () => Navigator.pop(sheetContext, c),
                            title: Text(
                              '${c.symbol} (${c.code})',
                              style: TextStyles.f14(context).medium,
                            ),
                            subtitle: Text(
                              c.name,
                              style: TextStyles.f12(
                                context,
                              ).medium.colorWith(Colors.grey),
                            ),
                            trailing: isSelected
                                ? const Icon(
                                    Icons.check,
                                    color: Color(0xFF3F51B5),
                                  )
                                : null,
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );

    if (selected == null) return;
    setState(() {
      _selectedCurrencyOverride = selected;
    });

    await HiveService.put(
      HiveService.settingsBoxName,
      'currency_code',
      selected.code,
    );
    await HiveService.put(
      HiveService.settingsBoxName,
      'currency_selected',
      true,
    );

    if (!context.mounted) return;
    try {
      await context.read<ProfileCubit>().updateDefaultCurrency(
        currencyId: selected.id,
      );
      if (!context.mounted) return;
      CustomToast.showSuccessMessage(context, 'Currency updated');
    } catch (e) {
      if (!context.mounted) return;
      CustomToast.showErrorMessage(context, e.toString());
    }
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => LogoutDialog(),
    );

    if (shouldLogout != true) return;
    if (!mounted) return;
    await context.read<AuthCubit>().logout();
    if (!mounted) return;
    CustomToast.showSuccessMessage(context, 'Logged out');
    const LoginRoute().go(context);
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final isAuthenticated = authState is AuthSuccess;

    if (!isAuthenticated) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('My profile', style: TextStyles.f20(context).bold),
          centerTitle: true,
        ),
        body: Center(
          child: Text(
            'Please log in to view your profile.',
            style: TextStyles.f16(context).medium,
          ),
        ),
      );
    }

    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous is! AuthSuccess && current is AuthSuccess,
      listener: (context, state) => _ensureProfileLoaded(),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return SafeScaffold(
              body: const Center(child: LoadingAppIndicator()),
            );
          }

          if (state is ProfileFailure) {
            return SafeScaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text('My profile', style: TextStyles.f18(context).bold),
                centerTitle: true,
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: TextStyles.f14(context).medium,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<ProfileCubit>().loadProfile(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final user = (state as ProfileLoaded).user;

          return SafeScaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text('My profile', style: TextStyles.f20(context).bold),
              centerTitle: true,
            ),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: SizedBox(height: Sizes.marginV20)),

                SliverToBoxAdapter(
                  child: Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFFE8EAF6),
                                    Color(0xFF5C6BC0),
                                    Color(0xFF3949AB),
                                  ],
                                ),
                              ),
                              child: ClipOval(
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: AppAssetsImage(
                                    AppAssets.ASSETS_IMAGES_AVATAR_PNG,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3F51B5),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const AppAssetsSvg(
                                  AppAssets.ASSETS_ICONS_EDIT_SVG,
                                  width: 12,
                                  height: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Sizes.marginV12),
                        Text(
                          user.fullName,
                          style: TextStyles.f20(context).bold,
                        ),
                        SizedBox(height: Sizes.marginV4),
                        Text(
                          user.email,
                          style: TextStyles.f14(
                            context,
                          ).medium.colorWith(Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: Sizes.marginV32)),

                SliverToBoxAdapter(
                  child: Text(
                    'profile',
                    style: TextStyles.f18(context).bold,
                  ).paddingSymmetric(horizontal: Sizes.paddingH20),
                ),
                SliverToBoxAdapter(child: SizedBox(height: Sizes.marginV16)),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoTile(context, 'Full Name', user.fullName),
                      _buildInfoTile(context, 'Email Address', user.email),
                      _buildInfoTile(
                        context,
                        'Phone Number',
                        user.phone?.isNotEmpty == true ? user.phone! : '-',
                      ),
                    ],
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: Sizes.marginV24)),

                SliverToBoxAdapter(
                  child: Text(
                    'Security',
                    style: TextStyles.f18(context).bold,
                  ).paddingSymmetric(horizontal: Sizes.paddingH20),
                ),
                SliverToBoxAdapter(child: SizedBox(height: Sizes.marginV12)),

                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _buildSecurityItem(
                        context,
                        svgIcon: AppAssets.ASSETS_ICONS_LOCK_SVG,
                        title: 'Change Password',
                        subtitle: 'Last Change 3 months ago',
                      ),
                      _buildSecurityItem(
                        context,
                        svgIcon: AppAssets.ASSETS_ICONS_VIRTUAL_CURRENCY_SVG,
                        title: 'Virtual currency',
                        subtitle: () {
                          final hiveCurrency = HiveService.get(
                            HiveService.settingsBoxName,
                            'currency_code',
                            defaultValue: '',
                          ).toString();
                          final selected =
                              _selectedCurrencyOverride ??
                              _resolveCurrency(user.defaultCurrency) ??
                              _resolveCurrency(hiveCurrency);
                          if (selected != null) {
                            return '${selected.symbol} (${selected.code})';
                          }
                          return user.defaultCurrency.isNotEmpty
                              ? user.defaultCurrency
                              : 'USD';
                        }(),
                        hasArrow: false,
                        trailing: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                          size: 28,
                        ),
                        onTap: () =>
                            _pickCurrency(context, user.defaultCurrency),
                      ),
                      _buildSecurityItem(
                        context,
                        svgIcon: AppAssets.ASSETS_ICONS_REPORTS_SVG,
                        title: 'Reports',
                        onTap: () =>
                            context.push(const ReportsRoute().location),
                      ),
                      _buildSecurityItem(
                        context,
                        iconData: Icons.card_giftcard,
                        title: 'Rewards',
                        onTap: () => context.push(RewardsRoute().location),
                      ),
                      _buildSecurityItem(
                        context,
                        iconData: Icons.star,
                        title: 'Rate App',
                        onTap: () => context.push(RateAppRoute().location),
                      ),
                      _buildSecurityItem(
                        context,
                        hasArrow: false,
                        isLogout: true,
                        svgIcon: AppAssets.ASSETS_ICONS_LOGOUT_SVG,
                        title: 'Logout',
                        onTap: _confirmLogout,
                      ),
                    ],
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityItem(
    BuildContext context, {
    required String title,
    String? subtitle,
    String? svgIcon,
    IconData? iconData,
    Widget? trailing,
    bool hasArrow = true,
    bool isLogout = false,
    Function? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          isLogout
              ? AppAssetsSvg(svgIcon!, width: 50, height: 50)
              : Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8EAF6),
                    shape: BoxShape.circle,
                  ),

                  child: svgIcon != null
                      ? AppAssetsSvg(svgIcon, color: const Color(0xFF3F51B5))
                      : Icon(
                          iconData,
                          color: const Color(0xFF3F51B5),
                          size: 24,
                        ),
                ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null)
            trailing
          else if (hasArrow)
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    ).onTap(onTap);
  }
}
