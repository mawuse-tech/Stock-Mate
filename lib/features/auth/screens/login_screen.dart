import 'package:flutter/material.dart';
import '../data/auth_service.dart';
import 'widgets/auth_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.auth,
    required this.onAuthenticated,
    required this.onRegister,
    this.connectionMessage,
  });

  final AuthService auth;
  final ValueChanged<AuthUser> onAuthenticated;
  final VoidCallback onRegister;
  final String? connectionMessage;

  @override
  
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final user = await widget.auth.login(
        email: _email.text,
        password: _password.text,
      );
      if (mounted) widget.onAuthenticated(user);
    } on AuthException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) setState(() => _error = authConnectionErrorMessage);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => AuthPageLayout(
    title: 'Welcome back',
    subtitle: 'Sign in to manage your inventory.',
    connectionMessage: widget.connectionMessage,
    errorMessage: _error,
    form: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthEmailField(controller: _email),
          const SizedBox(height: 14),
          AuthPasswordField(
            controller: _password,
            onSubmitted: (_) => _submit(),
            validator: (value) =>
                value == null || value.isEmpty ? 'Enter your password' : null,
          ),
          const SizedBox(height: 22),
          AuthSubmitButton(label: 'Log in', busy: _busy, onPressed: _submit),
        ],
      ),
    ),
    footer: AuthSwitchLink(
      label: 'New to StockMate? Create an account',
      onPressed: _busy ? null : widget.onRegister,
    ),
  );
}
