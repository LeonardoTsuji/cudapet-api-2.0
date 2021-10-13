import 'package:cuidapet_api_2/app/database/i_database_connection.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_mysql_connection.dart';
import 'mock_results.dart';

class MockDatabaseConnection extends Mock implements IDatabaseConnection {
  final mySqlConnection = MockMysqlConnection();

  MockDatabaseConnection() {
    when(() => openConnection())
        .thenAnswer((invocation) async => mySqlConnection);
  }

  void mockQuery(MockResults mockResults, [List<Object>? params]) {
    when(() => mySqlConnection.query(any(), params ?? any()))
        .thenAnswer((_) async => mockResults);
  }
}
