import 'package:cuidapet_api_2/app/middlewares/middlewares.dart';
import 'package:shelf/src/response.dart';
import 'package:shelf/src/request.dart';

class DefaultTypeContent extends Middlewares {
  final String contentType;

  DefaultTypeContent(this.contentType);

  @override
  Future<Response> execute(Request request) async {
    final response = await innerHandler(request);
    return response.change(headers: {'content-type': contentType});
  }
}
