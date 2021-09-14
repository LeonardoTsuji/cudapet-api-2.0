import 'package:cuidapet_api_2/app/config/database_connection_config.dart';
import 'package:cuidapet_api_2/app/database/i_database_connection.dart';
import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';

@LazySingleton(as: IDatabaseConnection)
class DatabaseConnection implements IDatabaseConnection {
  final DatabaseConnectionConfig _config;

  DatabaseConnection(this._config);

  @override
  Future<MySqlConnection> openConnection() {
    return MySqlConnection.connect(ConnectionSettings(
      host: _config.host,
      port: _config.port,
      user: _config.user,
      password: _config.password,
      db: _config.databaseName,
    ));
  }
}
