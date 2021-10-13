import 'package:cuidapet_api_2/app/exceptions/user_notfound_exception.dart';
import 'package:cuidapet_api_2/app/logger/i_logger.dart';
import 'package:cuidapet_api_2/entities/user.dart';
import 'package:cuidapet_api_2/modules/user/data/user_repository.dart';
import 'package:test/test.dart';

import '../../../core/fixture/fixture_reader.dart';
import '../../../core/log/mock_logger.dart';
import '../../../core/mysql/mock_database_connection.dart';
import '../../../core/mysql/mock_results.dart';

void main() {
  late MockDatabaseConnection databaseConnection;
  late ILogger log;

  setUp(() {
    databaseConnection = MockDatabaseConnection();
    log = MockLogger();
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

      final userRepository =
          UserRepository(connection: databaseConnection, log: log);

      databaseConnection.mockQuery(mockResults);

      final user = await userRepository.findById(userId);

      expect(user, isA<User>());
      expect(user.id, 1);
    });
    test('Should return exception UserNotFoundException', () async {
      final id = 1;

      final mockResults = MockResults();
      databaseConnection.mockQuery(mockResults, [id]);

      final userRepository =
          UserRepository(connection: databaseConnection, log: log);

      var call = userRepository.findById;

      expect(() => call(id), throwsA(isA<UserNotfoundException>()));
    });
  });
}
