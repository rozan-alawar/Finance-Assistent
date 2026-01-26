import 'package:finance_assistent/src/core/routing/app_route.dart';
import 'package:finance_assistent/src/core/utils/extensions/widget_ex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/theme/app_color/extensions_color.dart';
import '../../../../core/config/theme/styles/styles.dart';
import '../../../../core/gen/app_assets.dart';
import '../../../../core/utils/extensions/go_router_ex.dart';
import '../../../../core/view/component/base/image.dart';
import '../../../../core/view/component/base/login_required_dialog.dart';
import '../../../auth/presentation/cubits/auth_cubit.dart';
import '../../../auth/presentation/cubits/auth_state.dart';
class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isGuest = context.select<AuthCubit, bool>(
          (cubit) => cubit.state.isGuest,
    );

    return AppBar(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  appSwitcherColors(context).primaryColor,
                ],
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
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Hello", style: TextStyles.f14(context).normal),
              Text("Rozan", style: TextStyles.f18(context).medium),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF9F9FA),
            ),
            child: AppAssetsSvg(AppAssets.ASSETS_ICONS_NOTIFICATION_SVG),
          ).onTap(() {
            if (isGuest) {
              showLoginRequiredDialog(
                context,
                title: 'Notifications',
                message:
                'Log in to receive notifications and stay informed about important updates.',
              );
              return;
            }

            context.push(const NotificationRoute().location);
          }),
        ],
      ),
    );
  }
}
