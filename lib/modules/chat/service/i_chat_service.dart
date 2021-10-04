import 'package:cuidapet_api_2/entities/chat.dart';
import 'package:cuidapet_api_2/modules/chat/view_models/chat_notify_view_model.dart';

abstract class IChatService {
  Future<int> startChat(int scheduleId);
  Future<void> notifyChat(ChatNotifyViewModel model);
  Future<List<Chat>> getChatsByUser(int user);
  Future<List<Chat>> getChatsBySupplier(int supplier);
  Future<void> endChat(int chatId);
}
