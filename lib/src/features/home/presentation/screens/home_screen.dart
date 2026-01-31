import 'package:finance_assistent/src/core/config/theme/app_color/extensions_color.dart';
import 'package:finance_assistent/src/core/gen/app_assets.dart';
import 'package:finance_assistent/src/core/utils/extensions/num_ex.dart';
import 'package:finance_assistent/src/core/utils/extensions/text_ex.dart';
import 'package:finance_assistent/src/core/utils/extensions/widget_ex.dart';
import 'package:finance_assistent/src/core/view/component/base/button.dart';
import 'package:finance_assistent/src/core/view/component/base/image.dart';
import 'package:finance_assistent/src/features/home/presentation/components/attention_card.dart';
import 'package:finance_assistent/src/features/home/presentation/components/custom_service_card.dart';
import 'package:finance_assistent/src/features/home/presentation/components/home_app_bar.dart';
import 'package:finance_assistent/src/features/home/presentation/components/payment_due_card.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/theme/styles/styles.dart';
import '../../../../core/routing/app_route.dart';
import '../../../../core/utils/const/sizes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                Text("\$31233", style: TextStyles.f16(context).bold),
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
                        {"Invoice", AppAssets.ASSETS_ICONS_INVOICE_SVG},
                        {"Debts", AppAssets.ASSETS_ICONS_DEBTS_SVG},
                        {"Expenses", AppAssets.ASSETS_ICONS_EXPENSES_SVG},
                        {"Revenues", AppAssets.ASSETS_ICONS_REVENUES_SVG},
                      ];
                      return CustomServiceCard(
                        label: service[index].first,
                        icon: service[index].last,
                      ).paddingOnly(
                        left: index == 0 ? 16 : 0,
                        right: index == service.length - 1 ? 16 : 0,
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
                  title: "You've Exceeded Your Budget",
                  progress: 0.5,
                  subTitle: "Review your expenses to stay on track",
                  icon: AppAssets.ASSETS_ICONS_INVOICE_SVG,
                  progressColor: appSwitcherColors(context).successColor,
                ),
                AttentionCard(
                  title: "You've Exceeded Your Budget",
                  progress: 0.7,
                  subTitle: "Review your expenses ",
                  icon: AppAssets.ASSETS_ICONS_EXPENSES_LIMIT_SVG,
                  progressColor: appSwitcherColors(context).primaryColor,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: appSwitcherColors(
                      context,
                    ).neutralColors.shade60.withValues(alpha: 0.3),
                  ),
                  child: Row(
                    children: [
                      AppAssetsImage(
                        AppAssets.ASSETS_IMAGES_TEST_PNG,
                        width: 30,
                        height: 30,
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
                                      color: appSwitcherColors(
                                        context,
                                      ).primaryColor,
                                      borderRadius: BorderRadius.circular(16),
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
