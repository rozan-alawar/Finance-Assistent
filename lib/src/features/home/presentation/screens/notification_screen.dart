import 'package:finance_assistent/src/core/config/theme/app_color/extensions_color.dart';
import 'package:finance_assistent/src/core/config/theme/styles/styles.dart';
import 'package:finance_assistent/src/core/gen/app_assets.dart';
import 'package:finance_assistent/src/core/utils/extensions/text_ex.dart';
import 'package:finance_assistent/src/core/utils/extensions/widget_ex.dart';
import 'package:finance_assistent/src/core/view/component/base/safe_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/const/sizes.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      appBar: AppBar(
        title: Text('Notification'),
        centerTitle: true,
        leading: SvgPicture.asset(
          AppAssets.ASSETS_ICONS_ARROW_LEFT_SVG,
          fit: BoxFit.scaleDown,
        ).onTap((){context.pop();}),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.paddingH16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Sizes.paddingV24),
                  Text("Today", style: TextStyles.f16(context).bold),
                  SizedBox(height: Sizes.paddingV16),
                  ListView.separated(
                    itemCount: 5,
                    shrinkWrap: true,
                    separatorBuilder: (context, index)=>SizedBox(height: Sizes.paddingV16,),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: appSwitcherColors(
                              context,
                            ).secondaryColor.withValues(alpha: 0.2),
                            child: SvgPicture.asset(
                              AppAssets.ASSETS_ICONS_WARNING_SVG,
                            ),
                          ),
                          SizedBox(width: Sizes.paddingV12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Spending Alert ",
                                style: TextStyles.f16(context).medium,
                              ),
                              Text(
                                "You’ve reached 90% of your Dining out budget. . 4h ago ",
                                maxLines: 2,
                                style: TextStyles.f12(context).colorWith(appCommonUIColors(context).black.withValues(alpha: 0.5)),
                              ),
                            ],
                          ),
                          SizedBox(width: Sizes.paddingV6),
                          CircleAvatar(radius: 6,backgroundColor: appSwitcherColors(context).primaryColor,),
                        ],
                      );
                    }
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
