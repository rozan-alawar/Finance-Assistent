import 'package:flutter/material.dart';

import '../../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../../core/config/theme/styles/styles.dart';
import '../../../../../core/gen/app_assets.dart';
import '../../../../../core/utils/extensions/widget_ex.dart';
import '../../../../../core/view/component/base/app_text_field.dart';
import '../../../../../core/view/component/base/image.dart';

class BillSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;

  const BillSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      prefixIcon:  AppAssetsSvg(AppAssets.ASSETS_ICONS_SEARCH_SVG,).paddingAll(16),
      suffix: AppAssetsSvg(AppAssets.ASSETS_ICONS_TUNE_SVG,).paddingAll(16),
      controller: controller,
      onChanged: onChanged,
      hint: 'Search for Bills',
      textFieldType: TextFieldType.other,
    );
  }
}
