import 'package:finance_assistent/src/core/view/component/base/image.dart';
import 'package:flutter/material.dart';

import '../../../../core/gen/app_assets.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.size, required this.message});

  final Size size;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFCEDF1), Color(0xFFE3E1FC)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppAssetsImage(
              AppAssets.ASSETS_IMAGES_USER_PLACEHOLDER_PNG,
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
