import 'package:flutter/material.dart';

import '../../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../../core/config/theme/styles/styles.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorPalette.gray10,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(
            Icons.search,
            color: ColorPalette.gray50,
            size: 22,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyles.f14(context),
              decoration: InputDecoration(
                hintText: 'Search for Bills',
                hintStyle: TextStyles.f14(context).copyWith(
                  color: ColorPalette.gray50,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          IconButton(
            onPressed: onFilterTap,
            icon: Icon(
              Icons.tune_rounded,
              color: ColorPalette.primary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
