import '../../domain/entity/ai_chat.dart';

class AiChatDataModel {
  String? chatId;
  String? message;

  AiChatDataModel({this.chatId, this.message});

  AiChatDataModel.fromJson(Map<String, dynamic> json) {
    chatId = json['chatId'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chatId'] = chatId;
    data['message'] = message;
    return data;
  }

  AiChat toEntity() {
    return AiChat(chatId: chatId, message: message);
  }
}
