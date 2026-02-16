import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../core/config/theme/styles/styles.dart';
import '../../../../core/gen/app_assets.dart';
import '../../../../core/utils/const/sizes.dart';
import '../../../../core/utils/extensions/text_ex.dart';
import '../../../../core/utils/extensions/widget_ex.dart';
import '../../../../core/view/component/base/app_text_field.dart';
import '../../../../core/view/component/base/image.dart';

class DebtSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;


  const DebtSearchBar({super.key, this.controller,  this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      prefixIcon:  AppAssetsSvg(AppAssets.ASSETS_ICONS_SEARCH_SVG,).paddingAll(16),
      controller: controller,
      onChanged: onChanged,
      hint: 'Search for Invoices',
      textFieldType: TextFieldType.other,
    );
  }
}
