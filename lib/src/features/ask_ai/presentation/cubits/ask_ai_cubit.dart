import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/local_storage/hive_service.dart';
import '../../data/models/chat_message_model.dart';
import '../../domain/usecases/get_chart_data_usecase.dart';
import '../../../budget/domain/usecase/ask_ai_usecase.dart';
import 'ask_ai_state.dart';

class AskAiCubit extends Cubit<AskAiState> {
  final GetChartDataUsecase getChartDataUsecase;
  final AskAIUseCase askAIUseCase;
  static const String _messagesKeyPrefix = 'messages_';
  static const String _chatIdKeyPrefix = 'chat_id_';
  String? _chatId;
  late final String _userStorageKey;

  AskAiCubit(this.getChartDataUsecase, this.askAIUseCase)
    : super(AskAiInitialState()) {
    _userStorageKey = _resolveUserStorageKey();
    _loadSavedConversation();
  }

  Future<void> sendMessage(String message) async {
    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty) return;

    final userMessage = ChatMessage(message: trimmedMessage, isUser: true);

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
    await _persistConversation();

    if (trimmedMessage.toLowerCase() == 'make me ai budget suggestion') {
      try {
        final chartDataList = await getChartDataUsecase.call();
        final aiResponse = ChatMessage(
          message: 'Here is your AI budget suggestion:',
          isUser: false,
          chartDataList: chartDataList,
        );
        await _emitResponse(aiResponse);
      } catch (e) {
        final aiResponse = ChatMessage(
          message: 'Failed to fetch AI budget suggestion: $e',
          isUser: false,
        );
        await _emitResponse(aiResponse);
      }
    } else {
      try {
        final aiChat = await askAIUseCase.execute(
          trimmedMessage,
          chatId: _chatId,
        );
        if (_chatId == null && aiChat.chatId != null) {
          _chatId = aiChat.chatId;
          await HiveService.put(
            HiveService.askAiBoxName,
            '$_chatIdKeyPrefix$_userStorageKey',
            _chatId,
          );
        }
        final aiResponse = ChatMessage(
          message: aiChat.message ?? 'No response',
          isUser: false,
        );
        await _emitResponse(aiResponse);
      } catch (e) {
        final aiResponse = ChatMessage(
          message: 'Failed to get AI response.',
          isUser: false,
        );
        await _emitResponse(aiResponse);
      }
    }
  }

  Future<void> _emitResponse(ChatMessage aiResponse) async {
    if (state is AskAiChatState) {
      final currentState = state as AskAiChatState;
      emit(
        currentState.copyWith(
          messages: [...currentState.messages, aiResponse],
          isLoading: false,
        ),
      );
      await _persistConversation();
    }
  }

  void sendSuggestionQuestion(String question) {
    sendMessage(question);
  }

  void _loadSavedConversation() {
    final rawMessages = HiveService.get(
      HiveService.askAiBoxName,
      '$_messagesKeyPrefix$_userStorageKey',
      defaultValue: const [],
    );
    final rawChatId = HiveService.get(
      HiveService.askAiBoxName,
      '$_chatIdKeyPrefix$_userStorageKey',
    );

    if (rawChatId is String && rawChatId.isNotEmpty) {
      _chatId = rawChatId;
    }

    if (rawMessages is! List || rawMessages.isEmpty) {
      return;
    }

    final messages = rawMessages
        .whereType<Map>()
        .map((item) => ChatMessage.fromMap(Map<String, dynamic>.from(item)))
        .toList();

    if (messages.isNotEmpty) {
      emit(AskAiChatState(messages: messages));
    }
  }

  Future<void> _persistConversation() async {
    if (state is! AskAiChatState) {
      return;
    }
    final currentState = state as AskAiChatState;
    final serializedMessages = currentState.messages
        .map((message) => message.toMap())
        .toList();

    await HiveService.put(
      HiveService.askAiBoxName,
      '$_messagesKeyPrefix$_userStorageKey',
      serializedMessages,
    );
  }

  String _resolveUserStorageKey() {
    final userMap = HiveService.get(HiveService.settingsBoxName, 'user');
    if (userMap is Map && userMap['id'] != null) {
      return userMap['id'].toString();
    }
    return 'guest';
  }
}
