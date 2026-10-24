import 'package:flutter/material.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/detail_page.dart';
import '../../../data/models/inventory_item.dart';

class InventoryDetailsScreen extends StatelessWidget {
  const InventoryDetailsScreen({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onUpdateQuantity,
  });

  final InventoryItem item;
  final VoidCallback onEdit;
  final VoidCallback onUpdateQuantity;

  @override
  Widget build(BuildContext context) => DetailPage(
    title: 'Item details',
    actions: [
      OutlinedButton.icon(
        onPressed: onEdit,
        icon: const Icon(Icons.edit_outlined),
        label: const Text('Edit'),
      ),
      FilledButton.icon(
        onPressed: onUpdateQuantity,
        icon: const Icon(Icons.add),
        label: const Text('Update quantity'),
      ),
    ],
    children: [
      HeroDetail(
        icon: Icons.inventory_2_outlined,
        title: item.name,
        subtitle: '${item.category}  ·  ${item.sku}',
        tag: item.status,
      ),
      DetailLine('Quantity', '${item.qty} ${item.unit}'),
      DetailLine('Purchase cost', '${formatGhc(item.cost)} / ${item.unit}'),
      DetailLine(
        'Selling price',
        '${formatGhc(item.sellingPrice)} / ${item.unit}',
      ),
      DetailLine('Restock when below', '${item.reorder} ${item.unit}'),
    ],
  );
}
