import 'package:flutter/material.dart';
import '../../features/auth/screens/auth_gate.dart';

class AppRouter {
  AppRouter._();

  static const initialRoute = '/';
  static Map<String, WidgetBuilder> get routes => {
    '/': (_) => const AuthGate(),
  };
}
