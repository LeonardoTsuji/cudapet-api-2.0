import 'package:cuidapet_api_2/app/routers/i_router.dart';
import 'package:shelf_router/shelf_router.dart';

class RouterConfig {
  final Router _router;
  final List<IRouter> _routers = [];

  RouterConfig(this._router);

  void configure() => _routers.forEach((r) => r.config(_router));
}
