import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/chat_message_model.dart';
import '../../domain/usecases/get_chart_data_usecase.dart';
import '../../../budget/domain/usecase/ask_ai_usecase.dart';
import 'ask_ai_state.dart';

class AskAiCubit extends Cubit<AskAiState> {
  final GetChartDataUsecase getChartDataUsecase;
  final AskAIUseCase askAIUseCase;
  String? _chatId;

  AskAiCubit(this.getChartDataUsecase, this.askAIUseCase)
    : super(AskAiInitialState());

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

    if (message.trim().toLowerCase() == 'make me ai budget suggestion') {
      try {
        final chartDataList = await getChartDataUsecase.call();
        final aiResponse = ChatMessage(
          message: 'Here is your AI budget suggestion:',
          isUser: false,
          chartDataList: chartDataList,
        );
        _emitResponse(aiResponse);
      } catch (e) {
        final aiResponse = ChatMessage(
          message: 'Failed to fetch AI budget suggestion: $e',
          isUser: false,
        );
        _emitResponse(aiResponse);
      }
    } else {
      try {
        final aiChat = await askAIUseCase.execute(message, chatId: _chatId);
        if (_chatId == null && aiChat.chatId != null) {
          _chatId = aiChat.chatId;
        }
        final aiResponse = ChatMessage(
          message: aiChat.message ?? 'No response',
          isUser: false,
        );
        _emitResponse(aiResponse);
      } catch (e) {
        final aiResponse = ChatMessage(
          message: 'Failed to get AI response.',
          isUser: false,
        );
        _emitResponse(aiResponse);
      }
    }
  }

  void _emitResponse(ChatMessage aiResponse) {
    if (state is AskAiChatState) {
      final currentState = state as AskAiChatState;
      emit(
        currentState.copyWith(
          messages: [...currentState.messages, aiResponse],
          isLoading: false,
        ),
      );
    }
  }

  void sendSuggestionQuestion(String question) {
    sendMessage(question);
  }
}
