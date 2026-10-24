import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/sale.dart';

class SaleListItem extends StatelessWidget {
  const SaleListItem({super.key, required this.sale, this.onTap});

  final Sale sale;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFFF0EDFF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(Icons.restaurant_menu, color: lavender, size: 20),
    ),
    title: Text(sale.item, style: const TextStyle(fontWeight: FontWeight.w600)),
    subtitle: Text(
      '${sale.qty} items  ·  ${formatDate(sale.date)}',
      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
    ),
    trailing: Text(
      formatGhc(sale.total),
      style: const TextStyle(fontWeight: FontWeight.w700),
    ),
    onTap: onTap,
  );
}
