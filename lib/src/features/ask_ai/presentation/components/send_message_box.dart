import 'package:flutter/material.dart';

import '../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../core/config/theme/styles/styles.dart';
import '../../../../core/gen/app_assets.dart';
import '../../../../core/view/component/base/image.dart';

class SendMessageBox extends StatelessWidget {
  final ScrollController scrollController;
  final TextEditingController messageController = TextEditingController();
  SendMessageBox({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: messageController,
      decoration: InputDecoration(
        hintText: 'Ask anything you need...',
        border: InputBorder.none,
        hintStyle: TextStyles.f14(
          context,
        ).copyWith(color: ColorPalette.dueDateGrey2),
        suffixIcon: IconButton(
          onPressed: () {
            scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },

          icon: AppAssetsSvg(AppAssets.ASSETS_ICONS_MIC_SVG),
        ),
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        fillColor: Color(0xFFFAFAFA),
      ),
    );
  }
}
