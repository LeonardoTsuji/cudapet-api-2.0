import 'package:cuidapet_api_2/app/routers/i_router.dart';
import 'package:cuidapet_api_2/modules/chat/controller/chat_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf_router/src/router.dart';

class ChatRouter implements IRouter {
  @override
  void config(Router router) {
    final controller = GetIt.I.get<ChatController>();
    router.mount('/chats/', controller.router);
  }
}
