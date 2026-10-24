import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../shell/screens/main_shell.dart';
import '../data/auth_service.dart';
import 'login_screen.dart';
import 'register_screen.dart';


//AuthGate decides which screen to show: a loading indicator, the login or registration screen, or the main app if a user is signed in.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _auth = AuthService();
  AuthUser? _user;
  bool _loading = true;
  bool _showRegistration = false;
  String? _restoreError;

  @override
  void initState() {
    super.initState();
    // When the app opens, check whether this device already has a valid session.
    _restore();
  }

  Future<void> _restore() async {
    try {
      _user = await _auth.restoreSession();
    } catch (_) {
      _restoreError = _auth.connectionHint;
    }
    if (mounted) setState(() => _loading = false);
  }

  // LoginScreen and RegisterScreen call this after the backend accepts the user.
  void _onAuthenticated(AuthUser user) => setState(() => _user = user);

  Future<void> _logout() async {
    await _auth.signOut();
    if (mounted) setState(() => _user = null);
  }

  @override
  Widget build(BuildContext context) {
    // Wait for the saved-session check before choosing which screen to show.
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: lavender)),
      );
    }
    if (_user == null) {
      // No signed-in user: show either login or registration.
      if (_showRegistration) {
        return RegisterScreen(
          auth: _auth,
          onAuthenticated: _onAuthenticated,
          onLogin: () => setState(() => _showRegistration = false),
          connectionMessage: _restoreError,
        );
      }
      return LoginScreen(
        auth: _auth,
        onAuthenticated: _onAuthenticated,
        onRegister: () => setState(() => _showRegistration = true),
        connectionMessage: _restoreError,
      );
    }
    // A signed-in user can enter the main app.
    return MainShell(user: _user!, onLogout: _logout);
  }
}
