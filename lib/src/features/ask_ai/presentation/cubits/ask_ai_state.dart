import '../../data/models/chat_message_model.dart';

abstract class AskAiState {}

class AskAiInitialState extends AskAiState {}

class AskAiChatState extends AskAiState {
  final List<ChatMessage> messages;
  final bool isLoading;

  AskAiChatState({required this.messages, this.isLoading = false});

  AskAiChatState copyWith({List<ChatMessage>? messages, bool? isLoading}) {
    return AskAiChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
