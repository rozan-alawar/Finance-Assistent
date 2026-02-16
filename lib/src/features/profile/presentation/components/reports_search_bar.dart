import 'package:finance_assistent/src/core/config/theme/app_color/extensions_color.dart';
import 'package:finance_assistent/src/core/gen/app_assets.dart';
import 'package:finance_assistent/src/core/utils/extensions/widget_ex.dart';
import 'package:finance_assistent/src/core/view/component/base/image.dart';
import 'package:flutter/material.dart';

import '../../../../core/view/component/base/app_text_field.dart';

class ReportsSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;

  const ReportsSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      prefixIcon:  AppAssetsSvg(AppAssets.ASSETS_ICONS_SEARCH_SVG,).paddingAll(16),
      suffix: AppAssetsSvg(AppAssets.ASSETS_ICONS_TUNE_SVG,).paddingAll(16).onTap(onFilterTap),
      controller: controller,
      onChanged: onChanged,
      hint: "Search for service",
      textFieldType: TextFieldType.other,
    );
  }
}
