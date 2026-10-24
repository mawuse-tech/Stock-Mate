part of '../../../features/shell/screens/main_shell.dart';

extension _InventoryView on _MainShellState {
  Widget inventory() => Column(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'Inventory',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
            ),
            FilledButton.tonalIcon(
              onPressed: showStockForm,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add item'),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: TextField(
          decoration: const InputDecoration(
            hintText: 'Search stock items',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (v) => updateState(() => inventorySearch = v),
        ),
      ),
      SizedBox(
        height: 54,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children:
              [
                    'All stock',
                    'Low stock',
                    'Out of stock',
                    'Grains',
                    'Produce',
                    'Protein',
                    'Drinks',
                  ]
                  .map(
                    (f) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 6,
                      ),
                      child: ChoiceChip(
                        label: Text(f),
                        selected: stockFilter == f,
                        onSelected: (_) => updateState(() => stockFilter = f),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
      Expanded(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
          children: filteredItems().isEmpty
              ? [
                  const EmptyState(
                    title: 'No stock items found',
                    message: 'Try another search or add an item.',
                    icon: Icons.inventory_2_outlined,
                  ),
                ]
              : filteredItems().map(stockCard).toList(),
        ),
      ),
    ],
  );

  List<InventoryItem> filteredItems() => items.where((i) {
    final queryMatch = i.name.toLowerCase().contains(
      inventorySearch.toLowerCase(),
    );
    final filterMatch =
        stockFilter == 'All stock' ||
        (stockFilter == 'Low stock' && i.qty > 0 && i.qty <= i.reorder) ||
        (stockFilter == 'Out of stock' && i.qty == 0) ||
        i.category == stockFilter;
    return queryMatch && filterMatch;
  }).toList();

  Widget stockCard(InventoryItem item) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => stockDetails(item),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: canvas,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(stockIcon(item.category), color: lavender),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    '${item.category}  •  ${item.sku}',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    '${item.qty} ${item.unit}  ·  Sell ${formatGhc(item.sellingPrice)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            StatusPill(item.status),
          ],
        ),
      ),
    ),
  );

  IconData stockIcon(String category) => switch (category) {
    'Grains' => Icons.grain,
    'Protein' => Icons.egg_alt_outlined,
    'Drinks' => Icons.local_drink_outlined,
    'Produce' => Icons.eco_outlined,
    'Packaging' => Icons.inventory_2_outlined,
    _ => Icons.water_drop_outlined,
  };

  void stockDetails(InventoryItem item) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => InventoryDetailsScreen(
        item: item,
        onEdit: () {
          Navigator.pop(context);
          showStockForm(existing: item);
        },
        onUpdateQuantity: () {
          Navigator.pop(context);
          showRestock(item);
        },
      ),
    ),
  );
}
