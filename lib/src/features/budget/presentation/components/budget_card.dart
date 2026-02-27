import 'package:finance_assistent/src/core/utils/extensions/pay_status_ex.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../core/config/theme/styles/styles.dart';
import '../../../../core/gen/app_assets.dart';
import '../../../../core/utils/const/sizes.dart';
import '../../../../core/view/component/base/image.dart';
import 'over_lapping_avatars.dart';

class BudgetCard extends StatelessWidget {
  final String username;
  final String dueDate;
  final String category;
  final double amount;
  final String status;
  final List<String>? otherUsersAvaters;
  const BudgetCard({
    super.key,
    required this.username,
    required this.dueDate,
    required this.category,
    required this.amount,
    required this.status,
    this.otherUsersAvaters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorPalette.fillGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAssetsImage(
                AppAssets.ASSETS_IMAGES_USER_PLACEHOLDER_PNG,
                width: 58,
                height: 58,
              ),
              const SizedBox(width: Sizes.paddingH8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Zena',
                    style: TextStyles.f16(context).copyWith(height: 1),
                  ),
                  const SizedBox(height: Sizes.paddingV8),
                  Text(
                    'Date: $dueDate',
                    style: TextStyles.f12(
                      context,
                    ).copyWith(color: ColorPalette.dueDateGrey2),
                  ),
                ],
              ),
              Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorPalette.redBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AppAssetsSvg(AppAssets.ASSETS_ICONS_DELETE_SVG),
              ),
              Container(
                margin: const EdgeInsets.only(left: Sizes.paddingH8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorPalette.dividerGrey3.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AppAssetsSvg(AppAssets.ASSETS_ICONS_EDIT_SVG),
              ),
            ],
          ),
          const SizedBox(height: Sizes.paddingV8),
          Text(
            category,
            style: TextStyles.f14(
              context,
            ).copyWith(color: ColorPalette.textBlackColor),
          ),
          const SizedBox(height: Sizes.paddingV8),
          OverlappingAvatars(
            imageUrls:
                otherUsersAvaters ??
                [
                  'https://i.pravatar.cc/150?img=1',
                  'https://i.pravatar.cc/150?img=2',
                  'https://i.pravatar.cc/150?img=3',
                ],
          ),
          const SizedBox(height: Sizes.paddingV8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(
                '\$${amount.toStringAsFixed(2)}',
                style: TextStyles.f16(
                  context,
                ).medium.copyWith(color: ColorPalette.textBlackColor),
              ),
              Container(
                decoration: BoxDecoration(
                  color: status.toPaymentStatus.color,
                  border: Border.all(color: status.toPaymentStatus.textColor),
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 25,
                ),
                child: Center(
                  child: Text(
                    status,
                    style: TextStyles.f12(
                      context,
                    ).copyWith(color: status.toPaymentStatus.textColor),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
