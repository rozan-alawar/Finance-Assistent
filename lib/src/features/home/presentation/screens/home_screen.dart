import 'package:finance_assistent/src/core/config/theme/app_color/extensions_color.dart';
import 'package:finance_assistent/src/core/gen/app_assets.dart';
import 'package:finance_assistent/src/core/utils/extensions/num_ex.dart';
import 'package:finance_assistent/src/core/utils/extensions/text_ex.dart';
import 'package:finance_assistent/src/core/utils/extensions/widget_ex.dart';
import 'package:finance_assistent/src/core/view/component/base/button.dart';
import 'package:finance_assistent/src/core/view/component/base/image.dart';
import 'package:finance_assistent/src/features/home/data/models/currency_model.dart';
import 'package:finance_assistent/src/features/home/presentation/components/attention_card.dart';
import 'package:finance_assistent/src/features/home/presentation/components/custom_service_card.dart';
import 'package:finance_assistent/src/features/home/presentation/components/home_app_bar.dart';
import 'package:finance_assistent/src/features/home/presentation/components/payment_due_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_assistent/src/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:finance_assistent/src/features/auth/presentation/cubits/auth_state.dart';
import 'package:finance_assistent/src/core/services/local_storage/hive_service.dart';

import '../../../../core/config/theme/styles/styles.dart';
import '../../../../core/routing/app_route.dart';
import '../../../../core/utils/const/sizes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    String currencyCode = "USD";
    String balance = "31,296";

    if (authState is AuthSuccess && authState.user != null) {
      currencyCode = authState.user!.defaultCurrency;
      balance = authState.user!.currentBalance;
    } else {
       currencyCode = HiveService.get(HiveService.settingsBoxName, 'guest_currency', defaultValue: 'USD');
    }

    final selectedCurrency = CurrencyModel.getByCode(currencyCode);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: HomeAppBar(),
      ),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Your current balance"),
                SizedBox(height: Sizes.marginV4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("$balance", style: TextStyles.f24(context).bold),
                    GestureDetector(
                      onTap: () {
                        SelectCurrencyRoute(
                          activeCurrencyCode: selectedCurrency.code,
                        ).push(context);
                      },
                      child: Row(
                        children: [
                          if (selectedCurrency.isAsset)
                            AppAssetsSvg(
                              selectedCurrency.flag,
                              width: 20,
                              height: 20,
                            )
                          else
                            Text(
                              selectedCurrency.flag,
                              style: TextStyle(fontSize: 20),
                            ),

                          SizedBox(width: 4),
                          Text(
                            selectedCurrency.code,
                            style: TextStyles.f14(context).medium,
                          ),
                          Icon(Icons.keyboard_arrow_down, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Sizes.marginV16),
                PaymentDueCard(),
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
                    itemBuilder: (context, index) {
                      final service = [
                        {"label": "Income", "icon": AppAssets.ASSETS_ICONS_REVENUES_SVG, "onTap": null},
                        {"label": "Bills", "icon": AppAssets.ASSETS_ICONS_INVOICE_SVG, "onTap": null},
                        {"label": "Debts", "icon": AppAssets.ASSETS_ICONS_DEBTS_SVG, "onTap": () => AddDebtRoute().push(context)},
                        {"label": "Expenses", "icon": AppAssets.ASSETS_ICONS_EXPENSES_SVG, "onTap": null},
                      ];
                      return GestureDetector(
                        onTap: service[index]["onTap"] as VoidCallback?,
                        child: CustomServiceCard(
                          label: service[index]["label"] as String,
                          icon: service[index]["icon"] as String,
                        ).paddingOnly(
                          left: index == 0 ? 16 : 0,
                          right: index == service.length - 1 ? 16 : 0,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        SizedBox(width: Sizes.paddingH8),
                    itemCount: 4,
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Attention Needed", style: TextStyles.f18(context).medium),

                AttentionCard(
                  title: "You've Exceeded Your Budget",
                  progress: 0.8,
                  subTitle: "Review your expenses to stay on track",
                  icon: AppAssets.ASSETS_ICONS_EDIT_DOC_SVG,
                  progressColor: appSwitcherColors(context).secondaryColor,
                ),
                AttentionCard(
                  title: "Bill Due Soon",
                  progress: 0.6,
                  subTitle: "Review and pay the invoice on time",
                  icon: AppAssets.ASSETS_ICONS_BILLS_SVG,
                  progressColor: Color(0xFF0D47A1),
                ),
                AttentionCard(
                  title: "Expenses Approaching Limit",
                  progress: 0.4,
                  subTitle: "Keep an eye on your spending",
                  icon: AppAssets.ASSETS_ICONS_EXPENSES_LIMIT_SVG,
                  progressColor: Color(0xFF536DFE), // Blue/Purple
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                    style: TextStyles.f14(context).normal
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
                                      color: Color(0xFF3F51B5), // Dark Blue
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "Ask AI",
                                      style: TextStyles.f14(context).medium
                                          .colorWith(
                                            appCommonUIColors(context).white,
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
  }
}
