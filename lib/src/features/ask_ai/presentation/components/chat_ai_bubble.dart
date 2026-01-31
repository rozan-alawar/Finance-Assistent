import 'package:flutter/material.dart';

import '../../../../core/gen/app_assets.dart';
import '../../../../core/view/component/base/image.dart';

class ChatBubbleAi extends StatelessWidget {
  const ChatBubbleAi({super.key, required this.size, required this.message});

  final Size size;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFFF7F7F7),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppAssetsSvg(
              AppAssets.ASSETS_ICONS_ASK_AI_SVG,
              width: 32,
              height: 32,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                message,
                style: TextStyle(color: Color(0xFF363636), fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
