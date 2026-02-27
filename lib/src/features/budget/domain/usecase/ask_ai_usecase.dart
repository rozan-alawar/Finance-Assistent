import '../entity/ai_chat.dart';
import '../repo/budget_repository.dart';

class AskAIUseCase {
  final BudgetRepository repository;

  AskAIUseCase(this.repository);

  Future<AiChat> execute(String message, {String? chatId}) async {
    return await repository.askAI(message, chatId: chatId);
  }
}
