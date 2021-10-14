import 'dart:convert';

import 'package:cuidapet_api_2/app/exceptions/database_exception.dart';
import 'package:cuidapet_api_2/app/exceptions/user_exists_exception.dart';
import 'package:cuidapet_api_2/app/exceptions/user_notfound_exception.dart';
import 'package:cuidapet_api_2/app/helpers/cripty_helper.dart';
import 'package:cuidapet_api_2/app/logger/i_logger.dart';
import 'package:cuidapet_api_2/entities/user.dart';
import 'package:cuidapet_api_2/modules/user/data/user_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../core/fixture/fixture_reader.dart';
import '../../../core/log/mock_logger.dart';
import '../../../core/mysql/mock_database_connection.dart';
import '../../../core/mysql/mock_mysql_exception.dart';
import '../../../core/mysql/mock_results.dart';

void main() {
  late MockDatabaseConnection databaseConnection;
  late ILogger log;
  late UserRepository userRepository;

  setUp(() {
    databaseConnection = MockDatabaseConnection();
    log = MockLogger();
    userRepository = UserRepository(connection: databaseConnection, log: log);
  });

  group('Group test findById', () {
    test('Should return user by id', () async {
      final userId = 1;
      final userFixtureDB = FixtureReader.getJsonData(
          'modules/user/data/fixture/find_by_id_success_fixture.json');

      final mockResults = MockResults(userFixtureDB, [
        'ios_token',
        'android_token',
        'refresh_token',
        'img_avatar',
      ]);

      databaseConnection.mockQuery(mockResults);

      final user = await userRepository.findById(userId);

      expect(user, isA<User>());
      expect(user.id, 1);
    });
    test('Should return exception UserNotFoundException', () async {
      final id = 1;

      final mockResults = MockResults();
      databaseConnection.mockQuery(mockResults, [id]);

      var call = userRepository.findById;

      expect(() => call(id), throwsA(isA<UserNotfoundException>()));
    });
  });
  group('Group test create user', () {
    test('Should create user with success', () async {
      final mockResults = MockResults();
      final userId = 1;

      when(() => mockResults.insertId).thenReturn(userId);
      databaseConnection.mockQuery(mockResults);

      final user = await userRepository.createUser(User(
        email: 'test@test.com',
        registerType: 'APP',
        imageAvatar: '',
        password: '123456',
      ));

      final userExpected = User(
        id: userId,
        email: 'test@test.com',
        registerType: 'APP',
        imageAvatar: '',
        password: '',
      );

      expect(user, userExpected);
    });

    test('Should throw DatabaseException', () async {
      databaseConnection.mockQueryException();

      var call = userRepository.createUser;

      expect(() => call(User()), throwsA(isA<DatabaseException>()));
    });

    test('Should throw UserExistsException', () async {
      final exception = MockMySqlException();

      when(() => exception.message).thenReturn('usuario.email_UNIQUE');
      databaseConnection.mockQueryException(mockMySqlException: exception);

      var call = userRepository.createUser;

      expect(() => call(User()), throwsA(isA<UserExistsException>()));
    });
  });
  group('Group test login with email and password', () {
    test('Should login with email and password', () async {
      final userFixtureDB = FixtureReader.getJsonData(
          'modules/user/data/fixture/login_with_email_password_fixture.json');

      final mockResults = MockResults(userFixtureDB, [
        'ios_token',
        'android_token',
        'refresh_token',
        'img_avatar',
      ]);

      final email = 'test@test.com';
      final password = '123456';

      databaseConnection.mockQuery(mockResults, [
        email,
        CriptyHelper.generateSha256Hash(password),
      ]);

      final userMap = jsonDecode(userFixtureDB);

      final userExpected = User(
        id: userMap['id'],
        email: userMap['email'],
        password: userMap['password'],
        registerType: userMap['registerType'],
        iosToken: userMap['iosToken'],
        androidToken: userMap['androidToken'],
        refreshToken: userMap['refreshToken'],
        socialKey: userMap['socialKey'],
        imageAvatar: userMap['imageAvatar'],
        supplierId: userMap['supplierId'],
      );

      final user =
          await userRepository.loginWithEmailPassword(email, password, false);

      expect(user, isNotNull);
    });
    test(
        'Should not login with email and password and return UserNotfoundException',
        () async {
      final email = 'test@test.com';
      final password = '123456';

      databaseConnection.mockQueryException(params: [
        email,
        CriptyHelper.generateSha256Hash(password),
      ]);

      final call = userRepository.loginWithEmailPassword;

      expect(() => call(email, password, false),
          throwsA(isA<DatabaseException>()));
    });
  });

  group('Group test login by email social key', () {
    test('Should login by email social key', () async {
      final userFixtureDB = FixtureReader.getJsonData(
          'modules/user/data/fixture/login_with_email_social_key.json');

      final mockResults = MockResults(userFixtureDB, [
        'ios_token',
        'android_token',
        'refresh_token',
        'img_avatar',
      ]);

      final email = 'test@test.com';
      final socialKey = '123';
      final socialType = 'Facebook';

      databaseConnection.mockQuery(mockResults, [email]);

      final userMap = jsonDecode(userFixtureDB);

      final userExpected = User(
        id: userMap['id'],
        email: userMap['email'],
        password: userMap['password'],
        registerType: userMap['registerType'],
        iosToken: userMap['iosToken'],
        androidToken: userMap['androidToken'],
        refreshToken: userMap['refreshToken'],
        socialKey: userMap['socialKey'],
        imageAvatar: userMap['imageAvatar'],
        supplierId: userMap['supplierId'],
      );

      final user = await userRepository.loginByEmailSocialKey(
          email, socialKey, socialType);

      expect(user, isNotNull);
      databaseConnection.verifyQueryCalled(params: [email]);
      databaseConnection.verifyQueryNeverCalled(params: [
        socialKey,
        socialType,
        userMap['id'],
      ]);
    });
    test('Should login by email social key and update socialId', () async {
      final userFixtureDB = FixtureReader.getJsonData(
          'modules/user/data/fixture/login_with_email_social_key.json');

      final mockResults = MockResults(userFixtureDB, [
        'ios_token',
        'android_token',
        'refresh_token',
        'img_avatar',
      ]);

      final email = 'test@test.com';
      final socialKey = 'G123';
      final socialType = 'Google';
      final userMap = jsonDecode(userFixtureDB);

      databaseConnection.mockQuery(mockResults, [email]);
      databaseConnection.mockQuery(mockResults, [
        socialKey,
        socialType,
        userMap['id'],
      ]);

      final userExpected = User(
        id: userMap['id'],
        email: userMap['email'],
        password: userMap['password'],
        registerType: userMap['registerType'],
        iosToken: userMap['iosToken'],
        androidToken: userMap['androidToken'],
        refreshToken: userMap['refreshToken'],
        socialKey: userMap['socialKey'],
        imageAvatar: userMap['imageAvatar'],
        supplierId: userMap['supplierId'],
      );

      final user = await userRepository.loginByEmailSocialKey(
          email, socialKey, socialType);

      expect(user, isNotNull);
      databaseConnection.verifyQueryCalled(params: [email]);
      databaseConnection.verifyQueryNeverCalled(params: [
        socialKey,
        socialType,
        userMap['id'],
      ]);
    });

    test(
        'Should not login by email social key and return UserNotfoundException',
        () async {
      final mockResults = MockResults();
      final email = 'test@test.com';
      final socialKey = '123';
      final socialType = 'Facebook';

      databaseConnection.mockQuery(mockResults, [email]);

      final call = userRepository.loginByEmailSocialKey;

      expect(() => call(email, socialKey, socialType),
          throwsA(isA<UserNotfoundException>()));
    });

    test('Should not login by email social key and return DatabaseException',
        () async {
      final email = 'test@test.com';
      final socialKey = '123';
      final socialType = 'Facebook';

      databaseConnection.mockQueryException(params: [email]);

      final call = userRepository.loginByEmailSocialKey;

      expect(() => call(email, socialKey, socialType),
          throwsA(isA<DatabaseException>()));
    });
  });
}
