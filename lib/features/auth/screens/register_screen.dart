import 'package:flutter/material.dart';
import '../data/auth_service.dart';
import 'widgets/auth_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required this.auth,
    required this.onAuthenticated,
    required this.onLogin,
    this.connectionMessage,
  });

  final AuthService auth;
  final ValueChanged<AuthUser> onAuthenticated;
  final VoidCallback onLogin;
  final String? connectionMessage;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
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
      final user = await widget.auth.register(
        name: _name.text,
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
    title: 'Create your account',
    subtitle: 'Set up your StockMate workspace.',
    connectionMessage: widget.connectionMessage,
    errorMessage: _error,
    form: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthNameField(controller: _name),
          const SizedBox(height: 14),
          AuthEmailField(controller: _email),
          const SizedBox(height: 14),
          AuthPasswordField(
            controller: _password,
            isNewPassword: true,
            onSubmitted: (_) => _submit(),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Enter your password';
              if (value.length < 8) return 'Use at least 8 characters';
              return null;
            },
          ),
          const SizedBox(height: 22),
          AuthSubmitButton(
            label: 'Create account',
            busy: _busy,
            onPressed: _submit,
          ),
        ],
      ),
    ),
    footer: AuthSwitchLink(
      label: 'Already have an account? Log in',
      onPressed: _busy ? null : widget.onLogin,
    ),
  );
}
