import 'package:flutter/material.dart';

import '../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../core/config/theme/styles/styles.dart';
import '../../../../core/gen/app_assets.dart';
import '../../../../core/utils/const/sizes.dart';
import '../../../../core/utils/extensions/text_ex.dart';
import '../../../../core/view/component/base/image.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search for Service',
        hintStyle: TextStyles.f14(context).colorWith(Colors.grey),
        fillColor: ColorPalette.fillGrey,
        contentPadding: const EdgeInsets.symmetric(
          vertical: Sizes.paddingV16,
          horizontal: Sizes.paddingH16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.redAccent, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.redAccent, width: 2),
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.only(
            top: Sizes.paddingV12,
            bottom: Sizes.paddingV12,
            left: Sizes.paddingH16,
            right: Sizes.paddingH4,
          ),
          child: AppAssetsSvg(
            AppAssets.ASSETS_ICONS_SEARCH_SVG,
            margin: EdgeInsets.all(2),
          ),
        ),
      ),
    );
  }
}
