import 'package:flutter/material.dart';

import '../../../config/theme/app_color/extensions_color.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({
    this.height,
    super.key,
    this.indent,
    this.endIndent,
    this.color,
  });
  final double? height;
  final double? indent;
  final double? endIndent;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      color: color ?? appSwitcherColors(context).neutralColors.shade60,
      indent: indent,
      endIndent: endIndent,
    );
  }
}
