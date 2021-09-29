import 'package:cuidapet_api_2/app/routers/i_router.dart';
import 'package:cuidapet_api_2/modules/categories/categories_router.dart';
import 'package:cuidapet_api_2/modules/schedules/schedule_router.dart';
import 'package:cuidapet_api_2/modules/supplier/supplier_router.dart';
import 'package:cuidapet_api_2/modules/user/user_router.dart';
import 'package:shelf_router/shelf_router.dart';

class RouterConfig {
  final Router _router;
  final List<IRouter> _routers = [
    UserRouter(),
    CategoriesRouter(),
    SupplierRouter(),
    ScheduleRouter(),
  ];

  RouterConfig(this._router);

  void configure() => _routers.forEach((r) => r.config(_router));
}
