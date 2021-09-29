import 'package:cuidapet_api_2/app/helpers/request_mapping.dart';

class UserUpdateTokenDeviceInputModel extends RequestMapping {
  int userId;
  late String token;
  late String platform;

  UserUpdateTokenDeviceInputModel(
      {required this.userId, required String dataRequest})
      : super(dataRequest);

  @override
  void map() {
    token = data['token'];
    platform = (data['plataform'].toLowerCase() == 'ios' ? 'ios' : 'android');
  }
}
