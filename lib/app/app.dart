import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../features/auth/screens/auth_gate.dart';
import 'theme/app_theme.dart';

class StockMateApp extends StatelessWidget {
  const StockMateApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: AppConstants.appName,
    debugShowCheckedModeBanner: false,
    theme: appTheme,
    home: const AuthGate(),
  );
}
