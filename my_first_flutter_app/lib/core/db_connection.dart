import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:postgres/postgres.dart';

class DbConnection {
  DbConnection._();

  static final DbConnection instance = DbConnection._();

  Connection? _connection;

  bool get isConnected => _connection?.isOpen ?? false;

  Future<void> connect() async {
    if (isConnected) return;

    try {
      final connection = await Connection.open(
        Endpoint(
          host: dotenv.get('NEON_HOST'),
          port: dotenv.getInt('NEON_PORT', fallback: 5432),
          database: dotenv.get('NEON_DATABASE'),
          username: dotenv.get('NEON_USERNAME'),
          password: dotenv.get('NEON_PASSWORD'),
        ),
        settings: const ConnectionSettings(sslMode: SslMode.verifyFull),
      );

      _connection = connection;

      final result = await connection.execute('SELECT 1 AS connection_test');

      debugPrint('Database connection successful!');
      debugPrint('Test result: ${result.first[0]}');
    } catch (e) {
      debugPrint('Database connection failed: $e');
      await close();
      rethrow;
    }
  }

  Connection get connection {
    if (!isConnected) {
      throw StateError('Database is not connected.');
    }

    return _connection!;
  }

  Future<void> close() async {
    if (_connection != null) {
      await _connection!.close();
      _connection = null;
      debugPrint('Database connection closed.');
    }
  }
}
