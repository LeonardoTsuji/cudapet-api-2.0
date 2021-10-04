import 'package:cuidapet_api_2/app/exceptions/request_validation_exception.dart';
import 'package:cuidapet_api_2/app/helpers/request_mapping.dart';

class UserConfirmInputModel extends RequestMapping {
  int userId;
  String accessToken;
  String? iosDeviceToken;
  String? androidDeviceToken;
  UserConfirmInputModel(
      {required this.userId, required this.accessToken, required String data})
      : super(data);

  @override
  void map() {
    iosDeviceToken = data['ios_token'];
    androidDeviceToken = data['android_token'];
  }

  void validateRequest() {
    final errors = <String, String>{};

    if (iosDeviceToken == null && androidDeviceToken == null) {
      errors['ios_token or android_token'] = 'required';
    }

    if (errors.isNotEmpty) {
      throw RequestValidationException(errors);
    }
  }
}
