import 'package:cuidapet_api_2/app/exceptions/service_exception.dart';
import 'package:cuidapet_api_2/app/exceptions/user_notfound_exception.dart';
import 'package:cuidapet_api_2/app/helpers/jwt_helper.dart';
import 'package:cuidapet_api_2/app/logger/i_logger.dart';
import 'package:cuidapet_api_2/entities/user.dart';
import 'package:cuidapet_api_2/modules/user/data/i_user_repository.dart';
import 'package:cuidapet_api_2/modules/user/service/i_user_service.dart';
import 'package:cuidapet_api_2/modules/user/service/user_service.dart';
import 'package:cuidapet_api_2/modules/user/view_models/refresh_token_view_model.dart';
import 'package:cuidapet_api_2/modules/user/view_models/user_refresh_token_input_model.dart';
import 'package:dotenv/dotenv.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../core/log/mock_logger.dart';

class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late IUserRepository userRepository;
  late ILogger log;
  late IUserService userService;

  setUp(() {
    userRepository = MockUserRepository();
    log = MockLogger();
    userService = UserService(userRepository: userRepository, log: log);
    registerFallbackValue(User());
    load();
  });

  group('Group test login with email and password', () {
    test('Should login with email and password', () async {
      final id = 1;
      final email = 'test@test.com';
      final password = '123456';
      final supplierUser = false;
      final userMock = User(
        id: id,
        email: email,
      );

      when(() => userRepository.loginWithEmailPassword(
              email, password, supplierUser))
          .thenAnswer((invocation) async => userMock);

      final user = await userService.loginWithEmailPassword(
          email, password, supplierUser);

      expect(user, userMock);
      verify(() => userRepository.loginWithEmailPassword(
          email, password, supplierUser)).called(1);
    });
    test(
        'Should not login with email and password, should return UserNotfoundException',
        () async {
      final email = 'test@test.com';
      final password = '123456';
      final supplierUser = false;

      when(() => userRepository.loginWithEmailPassword(
              email, password, supplierUser))
          .thenThrow(UserNotfoundException(message: 'Usuário não encontrado'));

      final call = userService.loginWithEmailPassword;

      expect(() => call(email, password, supplierUser),
          throwsA(isA<UserNotfoundException>()));
      verify(() => userRepository.loginWithEmailPassword(
          email, password, supplierUser)).called(1);
    });
  });

  group('Group test login with social', () {
    test('Should login with social', () async {
      final id = 1;
      final email = 'test@test.com';
      final socialKey = '123';
      final socialType = 'Facebook';
      final userMock = User(
        id: id,
        email: email,
        socialKey: socialKey,
        registerType: socialType,
      );

      when(() => userRepository.loginByEmailSocialKey(
              email, socialKey, socialType))
          .thenAnswer((invocation) async => userMock);

      final user =
          await userService.loginWithSocial(email, '', socialType, socialKey);

      expect(user, userMock);
      verify(() => userRepository.loginByEmailSocialKey(
          email, socialKey, socialType)).called(1);
    });
    test('Should login social with user not found and create a new user',
        () async {
      final email = 'test@test.com';
      final password = '123456';
      final supplierUser = false;
      final socialKey = '123';
      final socialType = 'Facebook';

      final userCreated = User(
        id: 1,
        email: email,
        socialKey: socialKey,
        registerType: socialType,
      );

      when(() => userRepository.loginByEmailSocialKey(
              email, socialType, socialKey))
          .thenThrow(UserNotfoundException(message: 'Usuário não encontrado'));

      when(() => userRepository.createUser(any<User>()))
          .thenAnswer((invocation) async => userCreated);

      final user =
          await userService.loginWithSocial(email, '', socialType, socialKey);

      expect(user, userCreated);
      verify(() => userRepository.loginWithEmailPassword(
          email, password, supplierUser)).called(1);
      verify(() => userRepository.createUser(any<User>())).called(1);
    });

    group('Group test refresh token', () {
      test('Should generate refresh token', () async {
        env['refresh_token_not_before_hours'] = '0';
        final userId = 1;
        final accessToken = JwtHelper.generateJWT(userId, null);
        final refreshToken = JwtHelper.refreshToken(accessToken);
        final model = UserRefreshTokenInputModel(
          user: userId,
          accessToken: accessToken,
          dataRequest: '{"refresh_token": "$refreshToken"}',
        );

        when(() => userRepository.updateRefreshToken(any()))
            .thenAnswer((_) async => _);

        final responseToken = await userService.refreshToken(model);

        expect(responseToken, isA<RefreshTokenViewModel>());
        expect(responseToken.accessToken, isNotNull);
        expect(responseToken.refreshToken, isNotNull);
        verify(() => userRepository.updateRefreshToken(any())).called(1);
      });
      test('Should try refresh token JWT and return validate erro ', () async {
        final model = UserRefreshTokenInputModel(
          user: 1,
          accessToken: 'accessToken',
          dataRequest: '{"refresh_token": ""}',
        );

        final call = userService.refreshToken;

        expect(() => call(model), throwsA(isA<ServiceException>()));
      });
      test(
          'Should try refresh token JWT and return validate erro JWTException ',
          () async {
        final userId = 1;
        final accessToken = JwtHelper.generateJWT(userId, null);
        final refreshToken = JwtHelper.refreshToken('123');
        final model = UserRefreshTokenInputModel(
          user: userId,
          accessToken: accessToken,
          dataRequest: '{"refresh_token": "$refreshToken"}',
        );

        final call = userService.refreshToken;

        expect(() => call(model), throwsA(isA<ServiceException>()));
      });
    });
  });
}
