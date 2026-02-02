import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../core/config/theme/styles/styles.dart';
import '../../../../core/view/component/base/safe_scaffold.dart';
import '../components/chat_ai_bubble.dart';
import '../components/chat_bubble.dart';
import '../components/send_message_box.dart';
import '../cubits/ask_ai_cubit.dart';
import '../cubits/ask_ai_state.dart';

class AskAiScreen extends StatelessWidget {
  const AskAiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AskAiCubit(),
      child: BlocConsumer<AskAiCubit, AskAiState>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = context.read<AskAiCubit>();

          return SafeScaffold(
            appBar: AppBar(
              title: Text('Ask AI', style: TextStyles.f20(context).semiBold),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: state is AskAiChatState
                ? _buildChatView(context, state, cubit)
                : _buildInitialView(context, cubit),
          );
        },
      ),
    );
  }

  Widget _buildChatView(
    BuildContext context,
    AskAiChatState state,
    AskAiCubit cubit,
  ) {
    final scrollController = ScrollController();

    // Auto-scroll to bottom when new messages arrive
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                final message = state.messages[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: message.isUser
                      ? ChatBubble(size: Size.zero, message: message.message)
                      : ChatBubbleAi(size: Size.zero, message: message.message),
                );
              },
            ),
          ),
          if (state.isLoading)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: ColorPalette.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'AI is typing...',
                    style: TextStyles.f12(
                      context,
                    ).copyWith(color: ColorPalette.dueDateGrey2),
                  ),
                ],
              ),
            ),
          SendMessageBox(
            scrollController: scrollController,
            onSend: (message) => cubit.sendMessage(message),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialView(BuildContext context, AskAiCubit cubit) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'What can I help with?',
              style: TextStyles.f20(
                context,
              ).semiBold.copyWith(color: const Color.fromARGB(255, 75, 74, 74)),
            ),
          ),
          const SizedBox(height: 20),
          SendMessageBox(
            scrollController: ScrollController(),
            onSend: (message) => cubit.sendMessage(message),
          ),
          const SizedBox(height: 20),
          Text(
            'Suggested Questions',
            style: TextStyles.f16(
              context,
            ).medium.copyWith(color: const Color.fromARGB(255, 84, 84, 84)),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SuggestionQuestion(
                question: 'How can I save more?',
                onTap: () =>
                    cubit.sendSuggestionQuestion('How can I save more?'),
              ),
              const SizedBox(width: 8),
              SuggestionQuestion(
                question: 'Make me AI budget suggestion',
                onTap: () => cubit.sendSuggestionQuestion(
                  'Make me AI budget suggestion',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SuggestionQuestion(
            question: 'Is my spending healthy?',
            onTap: () =>
                cubit.sendSuggestionQuestion('Is my spending healthy?'),
          ),
        ],
      ),
    );
  }
}

class SuggestionQuestion extends StatelessWidget {
  final String question;
  final VoidCallback? onTap;

  const SuggestionQuestion({super.key, required this.question, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          question,
          style: TextStyles.f12(context).copyWith(color: ColorPalette.primary),
        ),
      ),
    );
  }
}
