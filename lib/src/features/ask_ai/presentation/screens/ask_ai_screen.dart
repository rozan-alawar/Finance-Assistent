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
    int msg = 0;

    return BlocProvider(
      create: (context) => AskAiCubit(),
      child: BlocConsumer<AskAiCubit, AskAiState>(
        listener: (context, state) {},
        builder: (context, state) {
          return SafeScaffold(
            appBar: AppBar(
              title: Text('Ask AI', style: TextStyles.f20(context).semiBold),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: msg != 0
                ? Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: msg,
                            itemBuilder: (context, index) => Column(
                              children: [
                                const ChatBubble(
                                  size: Size.zero,
                                  message:
                                      "Hello there!\nIs my spending healthy?",
                                ),
                                ChatBubbleAi(
                                  size: Size.zero,
                                  message:
                                      'Your spending looks generally healthy. You’re saving 27% of your income, which is great. However, dining and entertainment are slightly above average. Cutting back by a month could boost your savings.',
                                ),
                              ],
                            ),
                          ),
                        ),
                        SendMessageBox(scrollController: ScrollController()),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'What can I help with?',
                            style: TextStyles.f20(context).semiBold.copyWith(
                              color: const Color.fromARGB(255, 75, 74, 74),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        SendMessageBox(scrollController: ScrollController()),
                        const SizedBox(height: 20),
                        Text(
                          'Suggested Questions',
                          style: TextStyles.f16(context).medium.copyWith(
                            color: const Color.fromARGB(255, 84, 84, 84),
                          ),
                        ),
                        const SizedBox(height: 8),

                        Row(
                          children: [
                            SuggestionQuestion(
                              question: 'How can I save more?',
                            ),
                            const SizedBox(width: 8),
                            SuggestionQuestion(
                              question: 'Make me AI budget suggestion',
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        SuggestionQuestion(question: 'Is my spending healthy?'),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}

class SuggestionQuestion extends StatelessWidget {
  final String question;
  const SuggestionQuestion({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        question,
        style: TextStyles.f12(context).copyWith(color: ColorPalette.primary),
      ),
    );
  }
}
