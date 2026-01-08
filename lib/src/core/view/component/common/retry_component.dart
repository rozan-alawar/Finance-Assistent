import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../config/theme/app_color/extensions_color.dart';
import '../../../config/theme/styles/styles.dart';
import '../../../utils/const/sizes.dart';
import '../base/button.dart';


class ScreenRetry extends StatelessWidget {
  const ScreenRetry({
    required this.description,
    required this.onRetry,
    super.key,
  });
  final void Function()? onRetry;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Sizes.screenPaddingV40,
        horizontal: Sizes.screenPaddingH40,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: appSwitcherColors(
                context,
              ).neutralColors.shade50.withValues(alpha: 0.07),
            ),
            child: Icon(
              CupertinoIcons.exclamationmark_triangle,
              color: appSwitcherColors(context).dangerColor,
              size: 50,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyles.f14(context).semiBold,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Sizes.marginV8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 262),
            child: Text(
              'تآكد من الاتصال بالانترنت وحاول مرة اخرى',
              style: TextStyles.f14(context).neutral80(context),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: Sizes.marginV24),
          AppButton(
            onPressed: onRetry,
            type: AppButtonType.primary,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh),
                SizedBox(width: Sizes.marginH8),
                Text('تحديث'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
