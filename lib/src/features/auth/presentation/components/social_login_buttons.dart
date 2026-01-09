import 'package:flutter/material.dart';

import '../../../../core/config/theme/app_color/extensions_color.dart';
import '../../../../core/config/theme/styles/styles.dart';
import '../../../../core/gen/app_assets.dart';
import '../../../../core/utils/const/sizes.dart';
import '../../../../core/view/component/base/button.dart';
import '../../../../core/view/component/base/image.dart';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.providerName,
    this.onPressed,
    required this.providerIcon,
  });

  final String providerName;
  final String providerIcon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      borderColor: appSwitcherColors(context).neutralColors.shade60,
      onPressed: onPressed,
      type: AppButtonType.outline,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppAssetsImage(providerIcon),
          SizedBox(width: Sizes.paddingH8),
          Text(providerName, style: TextStyles.f16(context).medium),
        ],
      ),
    );
  }
}
