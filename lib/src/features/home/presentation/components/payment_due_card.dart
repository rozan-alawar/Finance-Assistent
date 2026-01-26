import 'package:flutter/material.dart';

import '../../../../core/config/theme/app_color/extensions_color.dart';
import '../../../../core/config/theme/styles/styles.dart';
import '../../../../core/utils/const/sizes.dart';
import '../../../../core/utils/extensions/text_ex.dart';
import '../../../../core/view/component/base/button.dart';

class PaymentDueCard extends StatelessWidget {
  const PaymentDueCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            appSwitcherColors(context).primaryColor,
            appSwitcherColors(
              context,
            ).primaryColor.withValues(alpha: 0.4),
            appSwitcherColors(
              context,
            ).secondaryColor.withValues(alpha: 0.5),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Payment Due",
            style: TextStyles.f16(
              context,
            ).medium.colorWith(appCommonUIColors(context).white),
          ),
          SizedBox(height: Sizes.marginV16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "\$4567",
                style: TextStyles.f18(
                  context,
                ).bold.colorWith(appCommonUIColors(context).white),
              ),
              Spacer(),
              SizedBox(width: Sizes.marginH32,),
              Expanded(
                child: AppButton(
                  roundCorner: 20,
                  onPressed: () {},
                  type: AppButtonType.primary,
                  child: Text("Pay Now", style: TextStyles.f16(context).medium.colorWith(appCommonUIColors(context).white),),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
