import 'dart:convert';

import 'package:cuidapet_api_2/app/exceptions/user_notfound_exception.dart';
import 'package:cuidapet_api_2/app/logger/i_logger.dart';
import 'package:cuidapet_api_2/entities/user.dart';
import 'package:cuidapet_api_2/modules/user/controller/auth_controller.dart';
import 'package:cuidapet_api_2/modules/user/service/i_user_service.dart';
import 'package:dotenv/dotenv.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../core/fixture/fixture_reader.dart';
import '../../../core/log/mock_logger.dart';
import '../../../core/shelf/mock_shelf_request.dart';
import 'mock/mock_user_service.dart';

void main() {
  late IUserService userService;
  late ILogger log;
  late AuthController authController;
  late Request request;

  setUp(() {
    log = MockLogger();
    userService = MockUserService();
    authController = AuthController(userService: userService, log: log);
    request = MockShelfRequest();
    load();
  });

  group('Group test login', () {
    test('Should login with success', () async {
      final loginRequestFixture = FixtureReader.getJsonData(
          'modules/user/controller/fixture/login_with_email_password_request.json');

      final loginRequestData = jsonDecode(loginRequestFixture);
      final login = loginRequestData['login'];
      final password = loginRequestData['password'];
      final supplierUser = loginRequestData['supplier_user'];

      when(() => request.readAsString())
          .thenAnswer((invocation) async => loginRequestFixture);

      when(() =>
              userService.loginWithEmailPassword(login, password, supplierUser))
          .thenAnswer((invocation) async => User(id: 1, email: login));

      final response = await authController.login(request);

      final responseData = jsonDecode(await response.readAsString());
      expect(response.statusCode, 200);
      expect(responseData['access_token'], isNotEmpty);
      verify(() =>
              userService.loginWithEmailPassword(login, password, supplierUser))
          .called(1);
      verifyNever(
          () => userService.loginWithSocial(any(), any(), any(), any()));
    });
    test('Should return RequestValidationError', () async {
      final loginRequestFixture = FixtureReader.getJsonData(
          'modules/user/controller/fixture/login_with_email_password_request_validation_error.json');

      when(() => request.readAsString())
          .thenAnswer((invocation) async => loginRequestFixture);

      final response = await authController.login(request);

      final responseData = jsonDecode(await response.readAsString());
      expect(response.statusCode, 400);
      expect(responseData['password'], 'required');
      verifyNever(
          () => userService.loginWithEmailPassword(any(), any(), any()));
      verifyNever(
          () => userService.loginWithSocial(any(), any(), any(), any()));
    });
    test('Should return UserNotfoundException', () async {
      final loginRequestFixture = FixtureReader.getJsonData(
          'modules/user/controller/fixture/login_with_email_password_request.json');

      final loginRequestData = jsonDecode(loginRequestFixture);
      final login = loginRequestData['login'];
      final password = loginRequestData['password'];
      final supplierUser = loginRequestData['supplier_user'];

      when(() => request.readAsString())
          .thenAnswer((invocation) async => loginRequestFixture);

      when(() =>
              userService.loginWithEmailPassword(login, password, supplierUser))
          .thenThrow(UserNotfoundException(message: 'Usuário não encontrado'));

      final response = await authController.login(request);

      expect(response.statusCode, 403);
      verify(() => userService.loginWithEmailPassword(any(), any(), any()));
      verifyNever(
          () => userService.loginWithSocial(any(), any(), any(), any()));
    });
  });

  group('Group test login with social', () {
    test('Should login with social', () async {
      final loginRequestFixture = FixtureReader.getJsonData(
          'modules/user/controller/fixture/login_with_social_request.json');

      final loginRequestData = jsonDecode(loginRequestFixture);
      final login = loginRequestData['login'];
      final avatar = loginRequestData['avatar'];
      final socialType = loginRequestData['social_type'];
      final socialKey = loginRequestData['social_key'];

      when(() => request.readAsString())
          .thenAnswer((invocation) async => loginRequestFixture);

      when(() =>
              userService.loginWithSocial(login, avatar, socialType, socialKey))
          .thenAnswer((invocation) async => User(
              id: 1,
              email: login,
              imageAvatar: avatar,
              registerType: socialType,
              socialKey: socialType));

      final response = await authController.login(request);

      final responseData = jsonDecode(await response.readAsString());
      expect(response.statusCode, 200);
      expect(responseData['access_token'], isNotEmpty);
      verify(() =>
              userService.loginWithSocial(login, avatar, socialType, socialKey))
          .called(1);
      verifyNever(
          () => userService.loginWithEmailPassword(any(), any(), any()));
    });
    test('Should return RequestValidationError', () async {
      final loginRequestFixture = FixtureReader.getJsonData(
          'modules/user/controller/fixture/login_with_social_request_validation_error.json');

      when(() => request.readAsString())
          .thenAnswer((invocation) async => loginRequestFixture);

      final response = await authController.login(request);

      final responseData = jsonDecode(await response.readAsString());
      expect(response.statusCode, 400);
      expect(responseData['social_type'], 'required');
      expect(responseData['social_key'], 'required');
      verifyNever(
          () => userService.loginWithEmailPassword(any(), any(), any()));
      verifyNever(
          () => userService.loginWithSocial(any(), any(), any(), any()));
    });
  });
}
