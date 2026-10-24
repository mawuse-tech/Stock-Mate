import 'package:flutter/material.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/detail_page.dart';
import '../../../data/models/sale.dart';

class SaleDetailsScreen extends StatelessWidget {
  const SaleDetailsScreen({super.key, required this.sale});

  final Sale sale;

  @override
  Widget build(BuildContext context) => DetailPage(
    title: 'Sale details',
    children: [
      HeroDetail(
        icon: Icons.receipt_long,
        title: sale.item,
        subtitle: formatDate(sale.date),
        tag: sale.method,
      ),
      DetailLine('Quantity sold', '${sale.qty}'),
      DetailLine('Total amount', formatGhc(sale.total)),
      DetailLine('Payment method', sale.method),
    ],
  );
}
