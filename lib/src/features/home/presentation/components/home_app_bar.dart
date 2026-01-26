import 'package:finance_assistent/src/core/routing/app_route.dart';
import 'package:finance_assistent/src/core/utils/extensions/widget_ex.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/theme/app_color/extensions_color.dart';
import '../../../../core/config/theme/styles/styles.dart';
import '../../../../core/gen/app_assets.dart';
import '../../../../core/view/component/base/image.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, appSwitcherColors(context).primaryColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              shape: BoxShape.circle,
            ),
            child: AppAssetsImage(
              AppAssets.ASSETS_IMAGES_AVATAR_PNG,
              height: 35,
              width: 30,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Hello", style: TextStyles.f14(context).normal),
              Text("Rozan", style: TextStyles.f18(context).medium),
            ],
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: appSwitcherColors(context).neutralColors.shade60,
            ),
            child: AppAssetsSvg(AppAssets.ASSETS_ICONS_NOTIFICATION_SVG),
          ).onTap(() {
      context.push(NotificationRoute().location);
          }),
        ],
      ),
    );
  }
}
