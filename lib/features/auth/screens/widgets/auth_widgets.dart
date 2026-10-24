import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

const authConnectionErrorMessage =
    'Could not connect. Check the API and API_BASE_URL in .env.';

class AuthPageLayout extends StatelessWidget {
  const AuthPageLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.form,
    required this.footer,
    this.connectionMessage,
    this.errorMessage,
  });

  final String title;
  final String subtitle;
  final Widget form;
  final Widget footer;
  final String? connectionMessage;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: ink,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF777982),
                  ),
                ),
                const SizedBox(height: 28),
                if (connectionMessage != null && errorMessage == null) ...[
                  AuthMessageBox(message: connectionMessage!),
                  const SizedBox(height: 16),
                ],
                if (errorMessage != null) ...[
                  const SizedBox(height: 14),
                  AuthMessageBox(message: errorMessage!, isError: true),
                ],
                form,
                const SizedBox(height: 16),
                footer,
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class AuthNameField extends StatelessWidget {
  const AuthNameField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    textCapitalization: TextCapitalization.words,
    textInputAction: TextInputAction.next,
    decoration: const InputDecoration(
      labelText: 'Full name',
      prefixIcon: Icon(Icons.person_outline),
    ),
    validator: (value) =>
        value == null || value.trim().isEmpty ? 'Enter your name' : null,
  );
}

class AuthEmailField extends StatelessWidget {
  const AuthEmailField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    keyboardType: TextInputType.emailAddress,
    textInputAction: TextInputAction.next,
    autofillHints: const [AutofillHints.email],
    decoration: const InputDecoration(
      labelText: 'Email address',
      prefixIcon: Icon(Icons.mail_outline),
    ),
    validator: (value) {
      final email = value?.trim() ?? '';
      if (email.isEmpty) return 'Enter your email address';
      if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
        return 'Enter a valid email address';
      }
      return null;
    },
  );
}

class AuthPasswordField extends StatefulWidget {
  const AuthPasswordField({
    super.key,
    required this.controller,
    required this.validator,
    this.isNewPassword = false,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final bool isNewPassword;
  final ValueChanged<String>? onSubmitted;

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: widget.controller,
    obscureText: _hidePassword,
    autofillHints: [
      widget.isNewPassword ? AutofillHints.newPassword : AutofillHints.password,
    ],
    onFieldSubmitted: widget.onSubmitted,
    decoration: InputDecoration(
      labelText: 'Password',
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        tooltip: _hidePassword ? 'Show password' : 'Hide password',
        onPressed: () => setState(() => _hidePassword = !_hidePassword),
        icon: Icon(
          _hidePassword
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
        ),
      ),
    ),
    validator: widget.validator,
  );
}

class AuthSubmitButton extends StatelessWidget {
  const AuthSubmitButton({
    super.key,
    required this.label,
    required this.busy,
    required this.onPressed,
  });

  final String label;
  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 54,
    child: FilledButton(
      onPressed: busy ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: lavender,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: busy
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
    ),
  );
}

class AuthSwitchLink extends StatelessWidget {
  const AuthSwitchLink({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onPressed,
    child: Text(
      label,
      style: const TextStyle(color: ink, fontWeight: FontWeight.w600),
    ),
  );
}

class AuthMessageBox extends StatelessWidget {
  const AuthMessageBox({
    super.key,
    required this.message,
    this.isError = false,
  });

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: isError ? const Color(0xFFFFEBEF) : const Color(0xFFEAE5FF),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Text(
      message,
      style: TextStyle(
        color: isError ? const Color(0xFFB42345) : ink,
        fontSize: 13,
      ),
    ),
  );
}
