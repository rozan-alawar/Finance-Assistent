import 'package:flutter/material.dart';
import '../../../../core/gen/app_assets.dart';
import '../../../../core/utils/extensions/widget_ex.dart';
import '../../../../core/view/component/base/app_text_field.dart';
import '../../../../core/view/component/base/image.dart';

class SearchHeaderSection extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onMicPressed;
  final ValueChanged<String>? onChanged;


  const SearchHeaderSection({super.key, this.controller, this.onMicPressed, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      prefixIcon:  AppAssetsSvg(AppAssets.ASSETS_ICONS_SEARCH_SVG,).paddingAll(16),
      suffix: AppAssetsSvg(AppAssets.ASSETS_ICONS_MIC_SVG,).paddingAll(16).onTap(onMicPressed),
      controller: controller,
      onChanged: onChanged,
      hint: 'Search for service',
      textFieldType: TextFieldType.other,
    );
  }
}
