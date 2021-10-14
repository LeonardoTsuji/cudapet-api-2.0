import 'package:cuidapet_api_2/app/database/i_database_connection.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_mysql_connection.dart';
import 'mock_mysql_exception.dart';
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

  void mockQueryException(
      {MockMySqlException? mockMySqlException, List<Object>? params}) {
    var exception = mockMySqlException;

    if (exception == null) {
      exception = MockMySqlException();
      when(() => exception!.message).thenReturn('Erro mysql genérico');
    }

    when(() => mySqlConnection.query(any(), params ?? any()))
        .thenThrow(exception);
  }

  void verifyQueryCalled({int? called, List<Object>? params}) =>
      verify(() => mySqlConnection.query(any(), params ?? any()))
          .called(called ?? 1);

  void verifyQueryNeverCalled({int? called, List<Object>? params}) =>
      verifyNever(() => mySqlConnection.query(any(), params ?? any()));
}
