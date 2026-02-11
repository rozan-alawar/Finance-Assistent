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
    final authState = context.watch<AuthCubit>().state;
    final isGuest = authState is AuthGuest;
    final user = authState is AuthSuccess ? authState.user : null;

    return AppBar(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PopupMenuButton<String>(
            offset: const Offset(0, 50),
            onSelected: (value) {
              if (value == 'logout') {
                context.read<AuthCubit>().logout();
              } else if (value == 'login') {
                context.push('/login');
              }
            },
            itemBuilder: (context) => [
              if (isGuest || authState is AuthInitial)
                const PopupMenuItem(
                  value: 'login',
                  child: Row(
                    children: [
                      Icon(Icons.login, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Text('Log In', style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                )
              else
                const PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text('Log Out', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
            ],
            child: Container(
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
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Hello", style: TextStyles.f14(context).normal),
              Text(
                isGuest ? "Guest" : (user?.fullName ?? "User"),
                style: TextStyles.f18(context).medium,
              ),
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
