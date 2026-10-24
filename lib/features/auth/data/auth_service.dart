import 'auth_api.dart';
import 'auth_models.dart';
import 'auth_token_storage.dart';

export 'auth_models.dart';

class AuthService {
  AuthService({AuthApi? api, AuthTokenStorage? tokenStorage})
    : _api = api ?? AuthApi(),
      _tokenStorage = tokenStorage ?? AuthTokenStorage();

  final AuthApi _api;
  final AuthTokenStorage _tokenStorage;
  String? _token;

  Future<AuthUser?> restoreSession() async {
    _token = await _tokenStorage.read();
    if (_token == null) return null;
    try {
      return await _api.currentUser(_token!);
    } on AuthException catch (error) {
      if (error.statusCode == 401) {
        await signOut();
        return null;
      }
      rethrow;
    }
  }

  Future<AuthUser> register({
    required String name,
    required String email,
    required String password,
  }) => _authenticate('register', {
    'name': name.trim(),
    'email': email.trim(),
    'password': password,
  });

  Future<AuthUser> login({required String email, required String password}) =>
      _authenticate('login', {'email': email.trim(), 'password': password});

  Future<AuthUser> _authenticate(String path, Map<String, String> body) async {
    final data = await _api.authenticate(path, body);
    _token = data['token'] as String?;
    if (_token == null) {
      throw const AuthException('The server returned no session token.');
    }
    await _tokenStorage.write(_token!);
    return AuthUser.fromJson(data['user'] as Map<String, dynamic>);
  }

  Future<void> signOut() async {
    final token = _token;
    if (token != null) {
      try {
        await _api.logout(token);
      } catch (_) {
        // Clearing local storage is enough if the API is unreachable.
      }
    }
    _token = null;
    await _tokenStorage.clear();
  }

  String get connectionHint =>
      'Check that the API is running and API_BASE_URL in .env points to the right address. For a phone, use your computer’s LAN IP.';
}
