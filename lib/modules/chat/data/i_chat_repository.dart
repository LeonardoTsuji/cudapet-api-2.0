import 'package:cuidapet_api_2/entities/chat.dart';

abstract class IChatRepository {
  Future<int> startChat(int scheduleId);
  Future<Chat?> findChatById(int chatId);
  Future<List<Chat>> getChatsByUser(int user);
  Future<List<Chat>> getChatsBySupplier(int supplier);
  Future<void> endChat(int chatId);
}
