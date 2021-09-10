import 'package:dotenv/dotenv.dart' show load, env;

class Config {
  Future<void> loadConfig() async {
    await _loadEnv();
    final variavel = env['banco'];
    print(variavel);
  }

  Future<void> _loadEnv() async => load();
}
