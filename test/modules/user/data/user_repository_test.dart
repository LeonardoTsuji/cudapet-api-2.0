import 'package:cuidapet_api_2/app/database/i_database_connection.dart';
import 'package:cuidapet_api_2/app/logger/i_logger.dart';
import 'package:cuidapet_api_2/entities/user.dart';
import 'package:cuidapet_api_2/modules/user/data/user_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mysql1/mysql1.dart';
import 'package:test/test.dart';

import '../../../core/log/mock_logger.dart';
import '../../../core/mysql/mock_database_connection.dart';
import '../../../core/mysql/mock_mysql_connection copy.dart';
import '../../../core/mysql/mock_result_row.dart';
import '../../../core/mysql/mock_results.dart';

void main() {
  late IDatabaseConnection databaseConnection;
  late ILogger log;
  late MySqlConnection mySqlConnection;
  late Results mysqlResults;
  late ResultRow mysqlResultRow;

  setUp(() {
    databaseConnection = MockDatabaseConnection();
    log = MockLogger();
    mySqlConnection = MockMysqlConnection();
    mysqlResults = MockResults();
    mysqlResultRow = MockResultRow();
  });

  group('Group test findById', () {
    test('Should return user by id', () async {
      final userId = 1;
      final userRepository =
          UserRepository(connection: databaseConnection, log: log);

      when(() => mySqlConnection.close()).thenAnswer((_) async => _);
      when(() => mysqlResults.first).thenReturn(mysqlResultRow);
      when(() => mysqlResultRow['id']).thenAnswer((invocation) => 1);
      when(() => mySqlConnection.query(any(), any()))
          .thenAnswer((_) async => mysqlResults);
      when(() => mysqlResults.isEmpty).thenReturn(false);
      when(() => databaseConnection.openConnection())
          .thenAnswer((invocation) async => mySqlConnection);

      final user = await userRepository.findById(userId);

      expect(user, isA<User>());
      expect(user.id, 1);
    });
  });
}
