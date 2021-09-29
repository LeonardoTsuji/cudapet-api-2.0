import 'package:cuidapet_api_2/app/routers/i_router.dart';
import 'package:cuidapet_api_2/modules/supplier/controller/supplier_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf_router/src/router.dart';

class SupplierRouter implements IRouter {
  @override
  void config(Router router) {
    final supplierController = GetIt.I.get<SupplierController>();

    router.mount('/suppliers/', supplierController.router);
  }
}
