class AuthUser {
  const AuthUser({required this.id, required this.name, required this.email});

  final String id;
  final String name;
  final String email;

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
    id: json['id']?.toString() ?? 'N/A',
    name: json['name']?.toString() ?? 'N/A',
    email: json['email']?.toString() ?? 'N/A',
  );
}

class AuthException implements Exception {
  const AuthException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}
