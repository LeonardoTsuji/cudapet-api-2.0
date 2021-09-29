import 'package:cuidapet_api_2/app/routers/i_router.dart';
import 'package:cuidapet_api_2/modules/categories/controller/categories_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf_router/src/router.dart';

class CategoriesRouter implements IRouter {
  @override
  void config(Router router) {
    final categoryController = GetIt.I.get<CategoriesController>();
    router.mount('/categories/', categoryController.router);
  }
}
