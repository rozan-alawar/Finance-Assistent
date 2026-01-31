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
        color: Color(0xFFF9F9FA),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
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
