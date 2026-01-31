import 'package:flutter/material.dart';

import '../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../core/config/theme/app_color/extensions_color.dart';
import '../../../../core/config/theme/styles/styles.dart';
import '../../../../core/gen/app_assets.dart';
import '../../../../core/routing/app_route.dart';
import '../../../../core/utils/const/sizes.dart';
import '../../../../core/utils/extensions/text_ex.dart';
import '../../../../core/view/component/base/image.dart';

class AskAISection extends StatelessWidget {
  const AskAISection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Sizes.paddingH16,
        vertical: Sizes.paddingV16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: ColorPalette.fillGrey,
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
                        style: TextStyles.f14(context).normal.colorWith(
                          appSwitcherColors(context).neutralColors.shade80,
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
                          horizontal: Sizes.paddingH20,
                          vertical: Sizes.paddingV8,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF3F51B5), // Dark Blue
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Ask AI",
                          style: TextStyles.f14(
                            context,
                          ).medium.colorWith(appCommonUIColors(context).white),
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
    );
  }
}
