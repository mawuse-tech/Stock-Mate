import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class StatusPill extends StatelessWidget {
  const StatusPill(this.label, {super.key});
  final String label;
  @override
  Widget build(BuildContext context) {
    final color = label == 'In stock'
        ? mint
        : label == 'Low stock'
        ? const Color(0xFFE3AA41)
        : coral;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
