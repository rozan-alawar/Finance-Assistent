import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/const/sizes.dart';
import '../../../../core/utils/extensions/text_ex.dart';
import '../../../../core/config/theme/styles/styles.dart';

class DebtSummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final String svgPath;
  final Color iconColor;

  const DebtSummaryCard({
    required this.title,
    required this.amount,
    required this.svgPath,
    required this.iconColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Sizes.paddingV12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(Sizes.radius16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(Sizes.radius8),
            ),
            child: SvgPicture.asset(
              svgPath,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              width: 18,
              height: 18,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyles.f14(context).colorWith(Colors.grey.shade500),
          ),
          const SizedBox(height: 2),
          Text(
            '\$$amount',
            style: TextStyles.f16(context).bold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}