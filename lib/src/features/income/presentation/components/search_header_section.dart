import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../core/config/theme/styles/styles.dart';
import '../../../../core/gen/app_assets.dart';
import '../../../../core/utils/const/sizes.dart';
import '../../../../core/utils/extensions/text_ex.dart';
import '../../../../core/view/component/base/image.dart';

class SearchHeaderSection extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onMicPressed;

  const SearchHeaderSection({super.key, this.controller, this.onMicPressed});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: ColorPalette.primary,
      decoration: InputDecoration(
        hintText: 'Search for service',
        hintStyle: TextStyles.f14(context).colorWith(Colors.grey),
        filled: true,
        fillColor: ColorPalette.fillGrey,

        contentPadding: const EdgeInsets.symmetric(vertical: Sizes.paddingV16),

        prefixIcon: Padding(
          padding: const EdgeInsets.only(
            left: Sizes.paddingH16,
            right: Sizes.paddingH8,
          ),
          child: AppAssetsSvg(AppAssets.ASSETS_ICONS_SEARCH_SVG),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 40),
        suffixIcon: IconButton(
          onPressed: onMicPressed,
          icon: AppAssetsSvg(
            AppAssets.ASSETS_ICONS_MIC_SVG,

            color: const Color(0xFF3F51B5),
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
    );
  }
}
