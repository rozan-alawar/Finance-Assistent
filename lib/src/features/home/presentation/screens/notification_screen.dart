import 'package:finance_assistent/src/core/gen/app_assets.dart';
import 'package:finance_assistent/src/core/view/component/base/safe_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/const/sizes.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  SafeScaffold(
      appBar: AppBar(title: Text('Notification'),centerTitle: true,leading: SvgPicture.asset(AppAssets.ASSETS_ICONS_ARROW_LEFT_SVG, fit: BoxFit.scaleDown,),),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal:  Sizes.paddingH16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text("Notification"),
                ],),
              ),
            )
          ],
        ));
  }
}
