import 'package:flutter/material.dart';

import '../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../core/config/theme/styles/styles.dart';
import '../../../../core/gen/app_assets.dart';
import '../../../../core/view/component/base/image.dart';

class SendMessageBox extends StatefulWidget {
  final ScrollController scrollController;
  final Function(String)? onSend;

  const SendMessageBox({
    super.key,
    required this.scrollController,
    this.onSend,
  });

  @override
  State<SendMessageBox> createState() => _SendMessageBoxState();
}

class _SendMessageBoxState extends State<SendMessageBox> {
  final TextEditingController messageController = TextEditingController();

  void _sendMessage() {
    final message = messageController.text.trim();
    if (message.isNotEmpty && widget.onSend != null) {
      widget.onSend!(message);
      messageController.clear();
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: messageController,
        maxLines: null,
        textInputAction: TextInputAction.send,
        onSubmitted: (_) => _sendMessage(),
        decoration: InputDecoration(
          hintText: 'Ask anything you need...',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          hintStyle: TextStyles.f14(
            context,
          ).copyWith(color: ColorPalette.dueDateGrey2),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {},
                icon: AppAssetsSvg(AppAssets.ASSETS_ICONS_MIC_SVG),
              ),
              IconButton(
                onPressed: _sendMessage,
                icon: Icon(Icons.send_rounded, color: ColorPalette.primary),
              ),
            ],
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: ColorPalette.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          fillColor: const Color(0xFFFAFAFA),
          filled: true,
        ),
      ),
    );
  }
}
