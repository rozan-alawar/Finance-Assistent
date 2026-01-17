import 'package:flutter/material.dart';

import '../../../../core/config/theme/app_color/extensions_color.dart';
import '../../../../core/config/theme/styles/styles.dart';
import '../../../../core/utils/const/sizes.dart';
import '../../../../core/view/component/base/image.dart';

class CustomServiceCard extends StatelessWidget {
  const CustomServiceCard({super.key, required this.label, required this.icon});
  final String label;
  final String icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125,
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: appSwitcherColors(
          context,
        ).neutralColors.shade60.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: appCommonUIColors(context).white,
            child: AppAssetsSvg(icon),
          ),
          SizedBox(height: Sizes.paddingV12),

          Text(label, style: TextStyles.f16(context)),
        ],
      ),
    );
  }
}
