import 'package:finance_assistent/src/core/config/theme/app_color/extensions_color.dart';
import 'package:finance_assistent/src/core/gen/app_assets.dart';
import 'package:finance_assistent/src/core/utils/extensions/text_ex.dart';
import 'package:finance_assistent/src/core/utils/extensions/widget_ex.dart';
import 'package:finance_assistent/src/core/view/component/base/app_refresh_indicator.dart';
import 'package:finance_assistent/src/core/view/component/base/image.dart';
import 'package:finance_assistent/src/core/view/component/base/safe_scaffold.dart';
import 'package:finance_assistent/src/features/home/presentation/components/attention_card.dart';
import 'package:finance_assistent/src/features/home/presentation/components/custom_service_card.dart';
import 'package:finance_assistent/src/features/home/presentation/components/home_app_bar.dart';
import 'package:finance_assistent/src/features/home/presentation/components/payment_due_card.dart';
import 'package:finance_assistent/src/features/home/presentation/cubit/home_overview_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/theme/styles/styles.dart';
import '../../../../core/di/dependency_injection.dart' as di;
import '../../../../core/routing/app_route.dart';
import '../../../../core/utils/const/sizes.dart';
import '../../../../core/view/component/base/indicator.dart';
import '../../../../core/view/component/base/login_required_dialog.dart';
import '../../../auth/presentation/cubits/auth_cubit.dart';
import '../../../auth/presentation/cubits/auth_state.dart';
import '../../../home/data/repo/home_repository.dart';
import '../../domain/home_overview.dart';
import '../../presentation/cubit/home_overview_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _onServiceTap(BuildContext context, String serviceName) {
    final authState = context.read<AuthCubit>().state;
    final isGuest = authState is AuthGuest;

    final isLoggedIn = authState is AuthSuccess;

    if (!isLoggedIn) {
      if (isGuest) {
        showLoginRequiredDialog(
          context,
          title: serviceName,
          message: 'Log in to use $serviceName to add and track your balance',
        );
        return;
      }

      return;
    }

    // User is logged in, navigate to the service
    switch (serviceName) {
      case "Income":
        context.push(IncomeOverviewRoute().location);
        break;
      case "Expenses":
        context.push(ExpensesRoute().location);
        break;
      case "Bills":
        context.push(BillRoute().location);
        break;
      case "Debts":
        context.push(DebtsRoute().location);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final isGuest = authState is AuthGuest;
    final user = authState is AuthSuccess ? authState.user : null;
    return BlocProvider(
      create: (_) => HomeOverviewCubit(di.sl<HomeRepository>())..fetch(),
      child: BlocBuilder<HomeOverviewCubit, HomeOverviewState>(
        builder: (context, pageState) {
          if (pageState is HomeOverviewLoading) {
            return Container(
              color: Colors.white,
              child: const LoadingAppIndicator(size: 36),
            );
          }

          return BlocBuilder<HomeOverviewCubit, HomeOverviewState>(
            builder: (context, overviewState) {
              String balanceText = isGuest
                  ? "0.00"
                  : user?.currentBalance ?? "0.00";
              String currencyCode = "USD";
              String expenseDueText;
              String symbol = "\$";

              if (overviewState is HomeOverviewLoaded) {
                balanceText = overviewState.overview.balance.current;
                currencyCode = overviewState.overview.currency.code;
                symbol = overviewState.overview.currency.symbol;
                expenseDueText =
                    "$symbol ${overviewState.overview.expenseDue.amount}";
              } else {
                expenseDueText = "\$0.00";
              }
              final appBarUser = overviewState is HomeOverviewLoaded
                  ? overviewState.overview.user
                  : OverviewUser(
                      id: (user?.id ?? ''),
                      fullName: isGuest ? 'Guest' : (user?.fullName ?? 'User'),
                      avatarUrl: null,
                    );
              return SafeScaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(70),
                  child: HomeAppBar(user: appBarUser),
                ),
                body: AppRefreshIndicator(
                  onRefresh: () async =>
                      await context.read<HomeOverviewCubit>().fetch(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Your current balance"),
                          SizedBox(height: Sizes.marginV4),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    " $symbol $balanceText",
                                    style: TextStyles.f24(context).bold,
                                  ),
                                  GestureDetector(
                                    child: Row(
                                      children: [
                                        Text(
                                          currencyCode,
                                          style: TextStyles.f14(context).medium,
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: Sizes.marginV16),
                              PaymentDueCard(
                                amountText: expenseDueText,
                                onTrack: () {},
                              ),
                            ],
                          ),

                          SizedBox(height: Sizes.marginV24),
                        ],
                      ).paddingSymmetric(horizontal: 16, vertical: 12),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Service",
                            style: TextStyles.f18(context).medium,
                          ).paddingSymmetric(horizontal: 16),
                          SizedBox(
                            height: 130,
                            child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                final service = [
                                  {
                                    "Income",
                                    AppAssets.ASSETS_ICONS_REVENUES_SVG,
                                  },
                                  {"Bills", AppAssets.ASSETS_ICONS_INVOICE_SVG},
                                  {"Debts", AppAssets.ASSETS_ICONS_DEBTS_SVG},
                                  {
                                    "Expenses",
                                    AppAssets.ASSETS_ICONS_EXPENSES_SVG,
                                  },
                                ];

                                return GestureDetector(
                                  onTap: () {
                                    // if (service[index].first == "Income") {
                                    //   context.push(
                                    //     IncomeOverviewRoute().location,
                                    //   );
                                    // } else if (service[index].first ==
                                    //     "Debts") {
                                    //   context.push(DebtsRoute().location);
                                    // } else if (service[index].first ==
                                    //         "Bills" ||
                                    //     service[index].first == "Expenses") {
                                    _onServiceTap(
                                      context,
                                      service[index].first,
                                    );
                                    // }
                                  },
                                  child: CustomServiceCard(
                                    label: service[index].first,
                                    icon: service[index].last,
                                  ),
                                ).paddingOnly(
                                  left: index == 0 ? 16 : 0,
                                  right: index == service.length - 1 ? 16 : 0,
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: Sizes.paddingH8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<HomeOverviewCubit, HomeOverviewState>(
                            builder: (context, s) {
                              final items = s is HomeOverviewLoaded
                                  ? s.overview.attentionNeeded
                                  : const [];
                              if (items.isEmpty) {
                                return SizedBox.shrink();
                              }
                              final cards = items.map<Widget>((item) {
                                if (item is Map<String, dynamic>) {
                                  final title = item['title']?.toString() ?? '';
                                  final subTitle =
                                      item['subTitle']?.toString() ??
                                      item['subtitle']?.toString() ??
                                      '';
                                  final icon =
                                      item['icon']?.toString() ??
                                      AppAssets.ASSETS_ICONS_WARNING_SVG;
                                  final progressRaw = item['progress'];
                                  final progress = () {
                                    if (progressRaw is num) {
                                      return progressRaw.toDouble();
                                    }
                                    if (progressRaw is String) {
                                      final v = double.tryParse(progressRaw);
                                      if (v != null) return v;
                                    }
                                    return 0.0;
                                  }();
                                  return AttentionCard(
                                    title: title,
                                    subTitle: subTitle,
                                    icon: icon,
                                    progress: progress.clamp(0.0, 1.0),
                                  );
                                }
                                final title = item?.toString() ?? '';
                                return AttentionCard(
                                  title: title,
                                  subTitle: '',
                                  icon: AppAssets.ASSETS_ICONS_WARNING_SVG,
                                  progress: 0.0,
                                );
                              }).toList();
                              return Column(
                                spacing: 12,

                                children: [
                                  Text(
                                    "Attention Needed",
                                    style: TextStyles.f18(context).medium,
                                  ),
                                  ...cards,
                                ],
                              );
                            },
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                AppAssetsImage(
                                  AppAssets.ASSETS_IMAGES_TEST_PNG,
                                  width: 40,
                                  height: 40,
                                ),
                                SizedBox(width: Sizes.paddingH16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "AI Budget Suggestions",
                                        style: TextStyles.f16(context).medium,
                                      ),
                                      SizedBox(height: Sizes.paddingH2),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "Smarter budgeting starts with AI insights",
                                              style: TextStyles.f14(context)
                                                  .normal
                                                  .colorWith(
                                                    appSwitcherColors(
                                                      context,
                                                    ).neutralColors.shade80,
                                                  ),
                                              maxLines: 3,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              AskAiRoute().push(context);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 8,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Color(0xFF3F51B5),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                "Ask AI",
                                                style: TextStyles.f14(context)
                                                    .medium
                                                    .colorWith(
                                                      appCommonUIColors(
                                                        context,
                                                      ).white,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 16, vertical: 16),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
