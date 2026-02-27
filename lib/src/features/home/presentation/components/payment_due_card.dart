import 'package:finance_assistent/src/core/gen/app_assets.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/theme/app_color/extensions_color.dart';
import '../../../../core/config/theme/styles/styles.dart';
import '../../../../core/utils/const/sizes.dart';
import '../../../../core/utils/extensions/text_ex.dart';
import '../../../../core/view/component/base/button.dart';

class PaymentDueCard extends StatelessWidget {
  const PaymentDueCard({super.key, this.amountText, this.onTrack});

  final String? amountText;
  final VoidCallback? onTrack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.ASSETS_IMAGES_BG_PNG),
          fit: BoxFit.fill,
          opacity: 0.5,
        ),
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            appSwitcherColors(context).primaryColor,
            appSwitcherColors(context).primaryColor.withValues(alpha: 0.5),
            appSwitcherColors(context).secondaryColor.withValues(alpha: 0.5),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Expense Due",
            style: TextStyles.f16(
              context,
            ).medium.colorWith(appCommonUIColors(context).white),
          ),
          SizedBox(height: Sizes.marginV16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                amountText ?? "\$0.00",
                style: TextStyles.f20(
                  context,
                ).bold.colorWith(appCommonUIColors(context).white),
              ),
              Spacer(),
              SizedBox(width: Sizes.marginH32),
              Expanded(
                child: AppButton(
                  roundCorner: 16,
                  onPressed: onTrack,
                  type: AppButtonType.primary,
                  child: Text(
                    "Track",
                    style: TextStyles.f12(
                      context,
                    ).bold.colorWith(appCommonUIColors(context).white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
