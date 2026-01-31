import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/chat_message_model.dart';
import 'ask_ai_state.dart';

class AskAiCubit extends Cubit<AskAiState> {
  AskAiCubit() : super(AskAiInitialState());

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final userMessage = ChatMessage(message: message.trim(), isUser: true);

    if (state is AskAiInitialState) {
      emit(AskAiChatState(messages: [userMessage], isLoading: true));
    } else if (state is AskAiChatState) {
      final currentState = state as AskAiChatState;
      emit(
        currentState.copyWith(
          messages: [...currentState.messages, userMessage],
          isLoading: true,
        ),
      );
    }

    await Future.delayed(const Duration(seconds: 1));

    final aiResponse = ChatMessage(
      message: _generateAiResponse(message),
      isUser: false,
    );

    final currentState = state as AskAiChatState;
    emit(
      currentState.copyWith(
        messages: [...currentState.messages, aiResponse],
        isLoading: false,
      ),
    );
  }

  String _generateAiResponse(String userMessage) {
    return "Your spending looks generally healthy. You’re saving 27% of your income, which is great. However, dining and entertainment are slightly above average. Cutting back by \$100–\$150 a month could boost your savings.";
  }

  void sendSuggestionQuestion(String question) {
    sendMessage(question);
  }
}
