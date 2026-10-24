import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class ApiConfig {
  static String get baseUrl {
    final value = dotenv.env['API_BASE_URL']?.trim();
    if (value == null || value.isEmpty) {
      throw StateError('Set API_BASE_URL in the .env file.');
    }
    return value.replaceFirst(RegExp(r'/+$'), '');
  }
}
