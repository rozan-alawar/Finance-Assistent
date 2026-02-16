import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../config/theme/styles/styles.dart';
import '../../../gen/app_assets.dart';
import '../../../utils/const/sizes.dart';
import 'image.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    required this.showBackButton,
    this.onBackButtonPressed,
    this.action,
  });
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackButtonPressed;
  final Widget? action;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: Sizes.paddingV16,
          horizontal: Sizes.paddingH16,
        ),
        child: Row(
          children: [
            showBackButton
                ? InkWell(
                    onTap: onBackButtonPressed ?? () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        context.pop();
                      }
                    },
                    child: Transform.flip(
                      flipX: Directionality.of(context) == TextDirection.rtl,
                      child: AppAssetsSvg(AppAssets.ASSETS_ICONS_ARROW_LEFT_SVG),
                    ),
                  )
                : SizedBox.shrink(),
            Expanded(
              child: Center(
                child: Text(title, style: TextStyles.f16(context).semiBold),
              ),
            ),
            if (action != null) action!,
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
