import 'package:flutter/material.dart';

import '../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../core/config/theme/styles/styles.dart';
import '../../../../core/gen/app_assets.dart';
import '../../../../core/view/component/base/image.dart';
import '../../data/model/grid_item_model.dart';

class CustomBudgetItem extends StatelessWidget {
  const CustomBudgetItem({
    super.key,
    required this.item,
    required this.index,
    required this.gridItems,
  });

  final GridItemModel item;
  final int index;
  final List<GridItemModel> gridItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorPalette.fillGrey,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: item.backgoundColor ?? const Color(0xFFFDF5F7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: AppAssetsSvg(
              item.icon ?? AppAssets.ASSETS_ICONS_MONEY_RECIVE_SVG,
              color: gridItems[index].iconColor,
              margin: const EdgeInsets.all(11),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.title ?? '',
            style: TextStyles.f14(context).copyWith(
              color: ColorPalette.titleGrey1,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '\$${item.amount?.toStringAsFixed(1) ?? '0.0'}',
                style: TextStyles.f16(
                  context,
                ).medium.copyWith(color: ColorPalette.textBlackColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 8),

              AppAssetsSvg(
                item.arrow ?? AppAssets.ASSETS_ICONS_INCREASE_ARROW_SVG,
                width: 12,
                color: gridItems[index].iconColor,
              ),
              const SizedBox(width: 4),
              Text(
                '${item.percentage?.abs().toStringAsFixed(1) ?? '0.0'}%',
                style: TextStyles.f12(
                  context,
                ).copyWith(color: gridItems[index].iconColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
