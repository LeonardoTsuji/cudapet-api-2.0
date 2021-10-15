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
    platform = (data['platform'].toLowerCase() == 'ios' ? 'ios' : 'android');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserUpdateTokenDeviceInputModel &&
        other.userId == userId &&
        other.token == token &&
        other.platform == platform;
  }

  @override
  int get hashCode => userId.hashCode ^ token.hashCode ^ platform.hashCode;
}
