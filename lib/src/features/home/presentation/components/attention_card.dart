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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(0xFFF5F7FA), // Light gray/blueish background
              ),
              child: AppAssetsSvg(icon, width: 24, height: 24),
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
            Spacer(),
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