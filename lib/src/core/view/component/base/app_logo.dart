import 'package:finance_assistent/src/core/config/theme/app_color/extensions_color.dart';
import 'package:flutter/material.dart';

import '../../../gen/app_assets.dart';
import 'image.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: appCommonUIColors(context).black.withValues(alpha: 0.1),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: AppAssetsImage(AppAssets.ASSETS_IMAGES_LOGO_PNG, fit: BoxFit.fill),
    );
  }
}
