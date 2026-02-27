import 'ai_chat_data_model.dart';

class AiChatModel {
  bool? success;
  AiChatDataModel? data;

  AiChatModel({this.success, this.data});

  AiChatModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? AiChatDataModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
