import 'package:flutter/material.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';

import '../../../../core/config/theme/app_color/extensions_color.dart';
import '../../../../core/config/theme/styles/styles.dart';
import '../../../../core/gen/app_assets.dart';
import '../../../../core/utils/const/sizes.dart';
import '../../../../core/utils/extensions/text_ex.dart';
import '../../../../core/view/component/base/image.dart';

class AttentionCard extends StatelessWidget {
  const AttentionCard({
    super.key,
    required this.title,
    required this.progress,
    required this.subTitle,
    required this.icon,
    this.progressColor,
  });
  final String title;
  final String subTitle;
  final String icon;
  final Color? progressColor;
  final double progress;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext, BoxConstraints)=>  Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: appSwitcherColors(context).neutralColors.shade60,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: appSwitcherColors(
                  context,
                ).primaryColor.withValues(alpha: 0.08),
              ),
              child: AppAssetsSvg(icon, width: 28, height: 28),
            ),
            SizedBox(width: Sizes.paddingH16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyles.f14(context).medium),
                Text(
                  subTitle,
                  style: TextStyles.f12(context).normal.colorWith(
                    appSwitcherColors(context).neutralColors.shade80,
                  ),
                ),
                SizedBox(height: Sizes.paddingH8),

                /// Progress bar (custom-like)
                LinearPercentIndicator(

                  percent: progress.clamp(0.0, 1.0),
                  lineHeight: 8,
                  padding: EdgeInsets.zero,
                  barRadius: const Radius.circular(20),
                  backgroundColor: appSwitcherColors(
                    context,
                  ).neutralColors.shade60,
                  progressColor:
                      progressColor ?? appSwitcherColors(context).primaryColor,
                  width: MediaQuery.of(context).size.width/1.7,
                ),


              ],
            ),
            Transform.flip(
              flipX: true,
              child: AppAssetsSvg(
                AppAssets.ASSETS_ICONS_ARROW_LEFT_SVG,
                width: 18,
                height: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
