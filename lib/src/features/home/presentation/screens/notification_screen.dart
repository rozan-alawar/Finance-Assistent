import 'package:finance_assistent/src/core/config/theme/app_color/extensions_color.dart';
import 'package:finance_assistent/src/core/config/theme/styles/styles.dart';
import 'package:finance_assistent/src/core/gen/app_assets.dart';
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
        ).onTap((){context.pop();},),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.paddingH16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Today", style: TextStyles.f16(context).medium),
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: appSwitcherColors(
                          context,
                        ).secondaryColor.withValues(alpha: 0.2),
                        child: SvgPicture.asset(
                          AppAssets.ASSETS_ICONS_WARNING_SVG,
                        ),
                      ),
                      title: Text(
                        "Spending Alert",
                        style: TextStyles.f14(context).medium,
                      ),
                      subtitle: Text(
                        "You’ve reached 90% of your Dining out budget. . 4h ago ",
                        style: TextStyles.f12(context).normal.copyWith(
                          color: appSwitcherColors(
                            context,
                          ).neutralColors.shade80,
                        ),
                      ),
                      trailing: CircleAvatar(
                        radius: 4,
                        backgroundColor: appSwitcherColors(
                          context,
                        ).primaryColor,
                      ),
                    ),
                    separatorBuilder: (context, index) =>
                        SizedBox(height: Sizes.paddingH16),
                    itemCount: 5,
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
